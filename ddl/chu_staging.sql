-- DDL de la base chu_staging
-- Généré depuis le metastore Hive (SHOW CREATE TABLE).
CREATE DATABASE IF NOT EXISTS chu_staging;

-- chu_staging.cog_commune
CREATE EXTERNAL TABLE `chu_staging.cog_commune`(
  `code_commune` string, 
  `typecom` string, 
  `libelle` string, 
  `code_departement` string, 
  `code_region` string)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/cog_commune'
;

-- chu_staging.cog_departement
CREATE EXTERNAL TABLE `chu_staging.cog_departement`(
  `code_departement` string, 
  `code_region` string, 
  `libelle` string)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/cog_departement'
;

-- chu_staging.cog_region
CREATE EXTERNAL TABLE `chu_staging.cog_region`(
  `code_region` string, 
  `libelle` string, 
  `libelle_norm` string)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/cog_region'
;

-- chu_staging.consultation
CREATE EXTERNAL TABLE `chu_staging.consultation`(
  `num_consultation` string, 
  `id_patient_pseudo` string, 
  `id_professionnel` string, 
  `code_diag` string, 
  `date_consultation` date)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/consultation'
;

-- chu_staging.deces
CREATE EXTERNAL TABLE `chu_staging.deces`(
  `id_deces` string, 
  `sexe` string, 
  `date_naissance` date, 
  `date_deces` date, 
  `date_approximative` boolean, 
  `age_deces` int, 
  `code_lieu_deces` string)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/deces'
;

-- chu_staging.diagnostic
CREATE EXTERNAL TABLE `chu_staging.diagnostic`(
  `code_diag` string, 
  `libelle` string)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/diagnostic'
;

-- chu_staging.diagnostic_membres
CREATE EXTERNAL TABLE `chu_staging.diagnostic_membres`(
  `code_diag` string, 
  `libelle` string, 
  `origine` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/staging/diagnostic_membres'
;

-- chu_staging.dim_diagnostic_travail
CREATE EXTERNAL TABLE `chu_staging.dim_diagnostic_travail`(
  `sk_diagnostic` int, 
  `code_diag` string, 
  `libelle` string, 
  `code_categorie` string, 
  `libelle_categorie` string, 
  `chapitre_cim10` string, 
  `origine` string, 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/staging/dim_diagnostic_travail'
;

-- chu_staging.dim_etablissement_travail
CREATE EXTERNAL TABLE `chu_staging.dim_etablissement_travail`(
  `sk_etablissement` int, 
  `identifiant_organisation` string, 
  `type_organisation` string, 
  `finess_site` string, 
  `finess_etablissement_juridique` string, 
  `raison_sociale_site` string, 
  `code_commune` string, 
  `code_departement` string, 
  `nom_departement` string, 
  `nom_region` string, 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/staging/dim_etablissement_travail'
;

-- chu_staging.dim_localisation_travail
CREATE EXTERNAL TABLE `chu_staging.dim_localisation_travail`(
  `sk_localisation` int, 
  `niveau` string, 
  `code_commune` string, 
  `nom_commune` string, 
  `code_departement` string, 
  `nom_departement` string, 
  `code_region` string, 
  `nom_region` string, 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/staging/dim_localisation_travail'
;

-- chu_staging.dim_patient_travail
CREATE EXTERNAL TABLE `chu_staging.dim_patient_travail`(
  `sk_patient` int, 
  `id_patient_pseudo` string, 
  `sexe` string, 
  `annee_naissance` int, 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/staging/dim_patient_travail'
;

-- chu_staging.dim_professionnel_travail
CREATE TABLE `chu_staging.dim_professionnel_travail`(
  `sk_professionnel` int, 
  `id_professionnel_source` string, 
  `type_identifiant` string, 
  `nom_affiche` string, 
  `categorie_professionnelle` string, 
  `profession` string, 
  `code_specialite` string, 
  `specialite` string, 
  `etab_principal_id` string, 
  `etab_principal_nom` string, 
  `mode_rattachement` string, 
  `nb_etablissements` int, 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/staging/dim_professionnel_travail'
;

-- chu_staging.dim_temps_travail
CREATE EXTERNAL TABLE `chu_staging.dim_temps_travail`(
  `sk_temps` int, 
  `date_jour` date, 
  `jour` int, 
  `mois` int, 
  `libelle_mois` string, 
  `trimestre` int, 
  `semestre` int, 
  `annee` int, 
  `jour_semaine` string, 
  `est_week_end` boolean, 
  `est_niveau_annee` boolean, 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/staging/dim_temps_travail'
;

-- chu_staging.etablissement
CREATE EXTERNAL TABLE `chu_staging.etablissement`(
  `identifiant_organisation` string, 
  `type_organisation` string, 
  `finess_site` string, 
  `finess_juridique` string, 
  `raison_sociale` string, 
  `code_commune` string, 
  `code_departement` string, 
  `code_postal` string)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/etablissement'
;

-- chu_staging.fait_consultation_travail
CREATE EXTERNAL TABLE `chu_staging.fait_consultation_travail`(
  `num_consultation` string, 
  `sk_temps` int, 
  `sk_patient` int, 
  `sk_professionnel` int, 
  `sk_diagnostic` int, 
  `sk_etablissement` int, 
  `sk_localisation` int, 
  `age_patient` int, 
  `tranche_age` string, 
  `mode_rattachement` string, 
  `nb` int, 
  `annee` int)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/fait_consultation_travail'
;

-- chu_staging.fait_deces_travail
CREATE EXTERNAL TABLE `chu_staging.fait_deces_travail`(
  `id_deces` string, 
  `sk_temps` int, 
  `sk_localisation` int, 
  `sexe` string, 
  `age_deces` int, 
  `tranche_age` string, 
  `date_approximative` boolean, 
  `nb` int, 
  `annee` int)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/fait_deces_travail'
;

-- chu_staging.fait_hospitalisation_travail
CREATE EXTERNAL TABLE `chu_staging.fait_hospitalisation_travail`(
  `num_hospitalisation` string, 
  `sk_temps_entree` int, 
  `sk_temps_sortie` int, 
  `sk_patient` int, 
  `sk_diagnostic` int, 
  `sk_etablissement` int, 
  `sk_localisation` int, 
  `age_patient` int, 
  `tranche_age` string, 
  `nb` int, 
  `duree_sejour_jours` int, 
  `annee` int)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/fait_hospitalisation_travail'
;

-- chu_staging.fait_satisfaction_travail
CREATE EXTERNAL TABLE `chu_staging.fait_satisfaction_travail`(
  `finess` string, 
  `sk_temps` int, 
  `sk_etablissement` int, 
  `sk_localisation` int, 
  `score` double, 
  `nb_repondants` int, 
  `est_classe` boolean, 
  `annee` int)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/fait_satisfaction_travail'
;

-- chu_staging.hospitalisation
CREATE EXTERNAL TABLE `chu_staging.hospitalisation`(
  `num_hospitalisation` string, 
  `id_patient_pseudo` string, 
  `identifiant_organisation` string, 
  `code_diag` string, 
  `libelle_diag` string, 
  `date_entree` date, 
  `date_sortie` date, 
  `duree_jours` int)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/hospitalisation'
;

-- chu_staging.localisation_controle
CREATE EXTERNAL TABLE `chu_staging.localisation_controle`(
  `source` string, 
  `code` string, 
  `nb_lignes` bigint)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/staging/localisation_controle'
;

-- chu_staging.localisation_membres
CREATE EXTERNAL TABLE `chu_staging.localisation_membres`(
  `niveau` string, 
  `code` string, 
  `code_commune` string, 
  `nom_commune` string, 
  `code_departement` string, 
  `nom_departement` string, 
  `code_region` string, 
  `nom_region` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/staging/localisation_membres'
;

-- chu_staging.patient_pseudo
CREATE EXTERNAL TABLE `chu_staging.patient_pseudo`(
  `id_patient_pseudo` string, 
  `sexe` string, 
  `date_naissance` date)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/patient_pseudo'
;

-- chu_staging.professionnel
CREATE EXTERNAL TABLE `chu_staging.professionnel`(
  `id_professionnel` string, 
  `type_identifiant` string, 
  `civilite` string, 
  `nom` string, 
  `prenom` string, 
  `categorie_professionnelle` string, 
  `profession` string, 
  `code_specialite` string)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/professionnel'
;

-- chu_staging.rattachement_professionnel
CREATE EXTERNAL TABLE `chu_staging.rattachement_professionnel`(
  `id_professionnel` string, 
  `identifiant_organisation` string, 
  `mode_rattachement` string, 
  `nb_etablissements` int)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/rattachement_professionnel'
;

-- chu_staging.satisfaction
CREATE EXTERNAL TABLE `chu_staging.satisfaction`(
  `annee` int, 
  `finess` string, 
  `finess_geo` string, 
  `region` string, 
  `nb_repondants` int, 
  `score` double, 
  `classement` string)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/satisfaction'
;

-- chu_staging.specialite
CREATE EXTERNAL TABLE `chu_staging.specialite`(
  `code_specialite` string, 
  `fonction` string, 
  `specialite` string)
PARTITIONED BY ( 
  `load_date` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\;', 
  'serialization.format'='\;') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  '/chu/staging/specialite'
;

-- chu_staging.temps_bornes
CREATE EXTERNAL TABLE `chu_staging.temps_bornes`(
  `annee_min` int, 
  `annee_max` int)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/staging/temps_bornes'
;
