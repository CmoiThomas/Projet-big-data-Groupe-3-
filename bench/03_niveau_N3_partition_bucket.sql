-- Niveau N3 : ORC + partitions + buckets.
-- Par rapport à N2 (entrepôt actuel, faits partitionnés par année) on ajoute :
--   - dim_patient partitionnée par sexe et tranche d'âge
--   - dim_localisation partitionnée par région
--   - dim_temps partitionnée par année
--   - des buckets sur les faits et les grosses dimensions
-- Les noms de tables et de colonnes sont les mêmes que dans chu_dwh pour
-- pouvoir lancer les mêmes requêtes.

CREATE DATABASE IF NOT EXISTS chu_n3 COMMENT 'Benchmark N3 : ORC + partitions + buckets' LOCATION '/chu/bench/n3';
USE chu_n3;
-- Uniquement pour la création : un seul fichier ORC ouvert à la fois (sinon Java heap space)
SET hive.optimize.sort.dynamic.partition=true;
SET mapreduce.map.memory.mb=2048;
SET mapreduce.map.java.opts=-Xmx1638m;
SET mapreduce.reduce.memory.mb=2048;
SET mapreduce.reduce.java.opts=-Xmx1638m;
-- Dimensions
-- dim_temps : partitionnée par année (une partition par année 2015-2023,
-- plus la partition par défaut pour le membre -1 dont l'année est vide)
DROP TABLE IF EXISTS dim_temps;
CREATE TABLE dim_temps (
  sk_temps INT, date_jour DATE, jour INT, mois INT, libelle_mois STRING, trimestre INT, semestre INT,
  jour_semaine STRING, est_week_end BOOLEAN, est_niveau_annee BOOLEAN, load_date STRING)
PARTITIONED BY (annee INT)
STORED AS ORC;
INSERT OVERWRITE TABLE dim_temps PARTITION (annee)
SELECT sk_temps, date_jour, jour, mois, libelle_mois, trimestre, semestre,
       jour_semaine, est_week_end, est_niveau_annee, load_date, annee
FROM chu_dwh.dim_temps;

-- dim_localisation : partitionnée par région, 2 buckets par partition
DROP TABLE IF EXISTS dim_localisation;
CREATE TABLE dim_localisation (
  sk_localisation INT, niveau STRING, code_commune STRING, nom_commune STRING,
  code_departement STRING, nom_departement STRING, code_region STRING, load_date STRING)
PARTITIONED BY (nom_region STRING)
CLUSTERED BY (sk_localisation) INTO 2 BUCKETS
STORED AS ORC;
INSERT OVERWRITE TABLE dim_localisation PARTITION (nom_region)
SELECT sk_localisation, niveau, code_commune, nom_commune, code_departement, nom_departement,
       code_region, load_date, nom_region
FROM chu_dwh.dim_localisation;

-- dim_patient : partitionnée par sexe et tranche d'âge (âge à la date du
-- chargement, calculé à partir de l'année de naissance), 4 buckets
DROP TABLE IF EXISTS dim_patient;
CREATE TABLE dim_patient (
  sk_patient INT, id_patient_pseudo STRING, annee_naissance INT, load_date STRING)
PARTITIONED BY (sexe STRING, tranche_age STRING)
CLUSTERED BY (sk_patient) INTO 4 BUCKETS
STORED AS ORC;
INSERT OVERWRITE TABLE dim_patient PARTITION (sexe, tranche_age)
SELECT sk_patient, id_patient_pseudo, annee_naissance, load_date, sexe,
       CASE WHEN annee_naissance IS NULL THEN 'Inconnu'
            WHEN year(load_date) - annee_naissance < 18 THEN '0-17'
            WHEN year(load_date) - annee_naissance < 40 THEN '18-39'
            WHEN year(load_date) - annee_naissance < 65 THEN '40-64'
            WHEN year(load_date) - annee_naissance < 80 THEN '65-79'
            ELSE '80+' END
FROM chu_dwh.dim_patient;

-- Grandes dimensions : bucketées sur leur clé de substitution
DROP TABLE IF EXISTS dim_etablissement;
CREATE TABLE dim_etablissement (
  sk_etablissement INT, identifiant_organisation STRING, type_organisation STRING, finess_site STRING,
  finess_etablissement_juridique STRING, raison_sociale_site STRING, code_commune STRING,
  code_departement STRING, nom_departement STRING, nom_region STRING, load_date STRING)
CLUSTERED BY (sk_etablissement) INTO 4 BUCKETS
STORED AS ORC;
INSERT OVERWRITE TABLE dim_etablissement SELECT * FROM chu_dwh.dim_etablissement;

DROP TABLE IF EXISTS dim_professionnel;
CREATE TABLE dim_professionnel (
  sk_professionnel INT, id_professionnel_source STRING, type_identifiant STRING, nom_affiche STRING,
  categorie_professionnelle STRING, profession STRING, code_specialite STRING, specialite STRING,
  etab_principal_id STRING, etab_principal_nom STRING, mode_rattachement STRING, nb_etablissements INT,
  load_date STRING)
CLUSTERED BY (sk_professionnel) INTO 8 BUCKETS
STORED AS ORC;
INSERT OVERWRITE TABLE dim_professionnel SELECT * FROM chu_dwh.dim_professionnel;

DROP TABLE IF EXISTS dim_diagnostic;
CREATE TABLE dim_diagnostic (
  sk_diagnostic INT, code_diag STRING, libelle STRING, code_categorie STRING, libelle_categorie STRING,
  chapitre_cim10 STRING, origine STRING, load_date STRING)
CLUSTERED BY (sk_diagnostic) INTO 2 BUCKETS
STORED AS ORC;
INSERT OVERWRITE TABLE dim_diagnostic SELECT * FROM chu_dwh.dim_diagnostic;
-- Faits : partition par année (comme Gold) + buckets sur la clé de
-- jointure la plus utilisée par les analyses
-- Consultations et hospitalisations : bucketées sur sk_patient, la clé
-- des taux d'hospitalisation (B3 à B5, patients distincts)
DROP TABLE IF EXISTS fait_consultation;
CREATE TABLE fait_consultation (
  num_consultation STRING, sk_temps INT, sk_patient INT, sk_professionnel INT, sk_diagnostic INT,
  sk_etablissement INT, sk_localisation INT, age_patient INT, tranche_age STRING, mode_rattachement STRING,
  nb INT, load_date STRING)
PARTITIONED BY (annee INT)
CLUSTERED BY (sk_patient) INTO 8 BUCKETS
STORED AS ORC;
INSERT OVERWRITE TABLE fait_consultation PARTITION (annee)
SELECT num_consultation, sk_temps, sk_patient, sk_professionnel, sk_diagnostic, sk_etablissement,
       sk_localisation, age_patient, tranche_age, mode_rattachement, nb, load_date, annee
FROM chu_dwh.fait_consultation;

DROP TABLE IF EXISTS fait_hospitalisation;
CREATE TABLE fait_hospitalisation (
  num_hospitalisation STRING, sk_temps_entree INT, sk_temps_sortie INT, sk_patient INT, sk_diagnostic INT,
  sk_etablissement INT, sk_localisation INT, age_patient INT, tranche_age STRING, nb INT,
  duree_sejour_jours INT, load_date STRING)
PARTITIONED BY (annee INT)
CLUSTERED BY (sk_patient) INTO 2 BUCKETS
STORED AS ORC;
INSERT OVERWRITE TABLE fait_hospitalisation PARTITION (annee)
SELECT num_hospitalisation, sk_temps_entree, sk_temps_sortie, sk_patient, sk_diagnostic, sk_etablissement,
       sk_localisation, age_patient, tranche_age, nb, duree_sejour_jours, load_date, annee
FROM chu_dwh.fait_hospitalisation;

-- Décès et satisfaction : bucketés sur sk_localisation, la clé des
-- analyses par région (B7, B8)
DROP TABLE IF EXISTS fait_deces;
CREATE TABLE fait_deces (
  id_deces STRING, sk_temps INT, sk_localisation INT, sexe STRING, age_deces INT, tranche_age STRING,
  date_approximative BOOLEAN, nb INT, load_date STRING)
PARTITIONED BY (annee INT)
CLUSTERED BY (sk_localisation) INTO 8 BUCKETS
STORED AS ORC;
INSERT OVERWRITE TABLE fait_deces PARTITION (annee)
SELECT id_deces, sk_temps, sk_localisation, sexe, age_deces, tranche_age, date_approximative, nb, load_date, annee
FROM chu_dwh.fait_deces;

DROP TABLE IF EXISTS fait_satisfaction;
CREATE TABLE fait_satisfaction (
  finess STRING, sk_temps INT, sk_etablissement INT, sk_localisation INT, score DOUBLE, nb_repondants INT,
  est_classe BOOLEAN, load_date STRING)
PARTITIONED BY (annee INT)
CLUSTERED BY (sk_localisation) INTO 2 BUCKETS
STORED AS ORC;
INSERT OVERWRITE TABLE fait_satisfaction PARTITION (annee)
SELECT finess, sk_temps, sk_etablissement, sk_localisation, score, nb_repondants, est_classe, load_date, annee
FROM chu_dwh.fait_satisfaction;

-- Statistiques (comme pour Gold)
ANALYZE TABLE fait_consultation PARTITION (annee) COMPUTE STATISTICS;
ANALYZE TABLE fait_hospitalisation PARTITION (annee) COMPUTE STATISTICS;
ANALYZE TABLE fait_deces PARTITION (annee) COMPUTE STATISTICS;
ANALYZE TABLE fait_satisfaction PARTITION (annee) COMPUTE STATISTICS;

-- Contrôles
SHOW PARTITIONS dim_patient;
SHOW PARTITIONS dim_localisation;
SELECT 'fait_consultation', COUNT(*) FROM fait_consultation
UNION ALL SELECT 'fait_deces', COUNT(*) FROM fait_deces
UNION ALL SELECT 'dim_patient', COUNT(*) FROM dim_patient;
