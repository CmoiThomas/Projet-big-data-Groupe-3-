-- DDL de la base chu_dwh
-- Généré depuis le metastore Hive (SHOW CREATE TABLE).
CREATE DATABASE IF NOT EXISTS chu_dwh;

-- chu_dwh.dim_diagnostic
CREATE EXTERNAL TABLE `chu_dwh.dim_diagnostic`(
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
  '/chu/dwh/dim_diagnostic/load_date=2026-10-28'
;

-- chu_dwh.dim_etablissement
CREATE EXTERNAL TABLE `chu_dwh.dim_etablissement`(
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
  '/chu/dwh/dim_etablissement/load_date=2026-10-28'
;

-- chu_dwh.dim_localisation
CREATE EXTERNAL TABLE `chu_dwh.dim_localisation`(
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
  '/chu/dwh/dim_localisation/load_date=2026-10-28'
;

-- chu_dwh.dim_patient
CREATE EXTERNAL TABLE `chu_dwh.dim_patient`(
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
  '/chu/dwh/dim_patient/load_date=2026-10-28'
;

-- chu_dwh.dim_professionnel
CREATE EXTERNAL TABLE `chu_dwh.dim_professionnel`(
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
  '/chu/dwh/dim_professionnel/load_date=2026-10-28'
;

-- chu_dwh.dim_temps
CREATE EXTERNAL TABLE `chu_dwh.dim_temps`(
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
  '/chu/dwh/dim_temps/load_date=2026-10-28'
;

-- chu_dwh.fait_consultation
CREATE EXTERNAL TABLE `chu_dwh.fait_consultation`(
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
  `load_date` string)
PARTITIONED BY ( 
  `annee` int)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/dwh/fait_consultation'
;

-- chu_dwh.fait_deces
CREATE EXTERNAL TABLE `chu_dwh.fait_deces`(
  `id_deces` string, 
  `sk_temps` int, 
  `sk_localisation` int, 
  `sexe` string, 
  `age_deces` int, 
  `tranche_age` string, 
  `date_approximative` boolean, 
  `nb` int, 
  `load_date` string)
PARTITIONED BY ( 
  `annee` int)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/dwh/fait_deces'
;

-- chu_dwh.fait_hospitalisation
CREATE EXTERNAL TABLE `chu_dwh.fait_hospitalisation`(
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
  `load_date` string)
PARTITIONED BY ( 
  `annee` int)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/dwh/fait_hospitalisation'
;

-- chu_dwh.fait_satisfaction
CREATE EXTERNAL TABLE `chu_dwh.fait_satisfaction`(
  `finess` string, 
  `sk_temps` int, 
  `sk_etablissement` int, 
  `sk_localisation` int, 
  `score` double, 
  `nb_repondants` int, 
  `est_classe` boolean, 
  `load_date` string)
PARTITIONED BY ( 
  `annee` int)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/dwh/fait_satisfaction'
;

-- chu_dwh.mesure_consultation_diagnostic
CREATE EXTERNAL TABLE `chu_dwh.mesure_consultation_diagnostic`(
  `annee` int, 
  `sk_diagnostic` int, 
  `nbre_consultation` bigint)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/dwh/mesures/consultation_diagnostic'
;

-- chu_dwh.mesure_consultation_etablissement
CREATE EXTERNAL TABLE `chu_dwh.mesure_consultation_etablissement`(
  `annee` int, 
  `sk_etablissement` int, 
  `nbre_consultation` bigint)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/dwh/mesures/consultation_etablissement'
;

-- chu_dwh.mesure_consultation_professionnel
CREATE EXTERNAL TABLE `chu_dwh.mesure_consultation_professionnel`(
  `annee` int, 
  `sk_professionnel` int, 
  `nbre_consultation` bigint)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/dwh/mesures/consultation_professionnel'
;

-- chu_dwh.mesure_deces
CREATE EXTERNAL TABLE `chu_dwh.mesure_deces`(
  `annee` int, 
  `nom_region` string, 
  `sexe` string, 
  `tranche_age` string, 
  `nbre_deces` bigint)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/dwh/mesures/deces'
;

-- chu_dwh.mesure_hospitalisation
CREATE EXTERNAL TABLE `chu_dwh.mesure_hospitalisation`(
  `annee` int, 
  `sexe` string, 
  `tranche_age` string, 
  `nbre_hospitalisation` bigint, 
  `nbre_patients_hospitalises` bigint, 
  `nbre_patients_pris_en_charge` bigint)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/dwh/mesures/hospitalisation'
;

-- chu_dwh.mesure_hospitalisation_diagnostic
CREATE EXTERNAL TABLE `chu_dwh.mesure_hospitalisation_diagnostic`(
  `sk_diagnostic` int, 
  `nbre_hospitalisation` bigint, 
  `nbre_patients_hospitalises` bigint, 
  `nbre_patients_diagnostic` bigint)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/dwh/mesures/hospitalisation_diagnostic'
;

-- chu_dwh.mesure_satisfaction
CREATE EXTERNAL TABLE `chu_dwh.mesure_satisfaction`(
  `annee` int, 
  `nom_region` string, 
  `nbre_etablissements` bigint, 
  `nbre_etablissements_classes` bigint, 
  `total_repondants` bigint, 
  `total_satisfaction` double, 
  `score_moyen_pondere` double)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  '/chu/dwh/mesures/satisfaction'
;

-- chu_dwh.v_consultation_diagnostic
CREATE VIEW `chu_dwh.v_consultation_diagnostic` AS SELECT `m`.`annee`, `d`.`code_diag`, `d`.`libelle`, `d`.`code_categorie`, `d`.`chapitre_cim10`,
`m`.`nbre_consultation`, `t`.`total_annee`,
ROUND(100 * `m`.`nbre_consultation` / `t`.`total_annee`, 3) AS `part_pct`
FROM `chu_dwh`.`mesure_consultation_diagnostic` `m`
JOIN `chu_dwh`.`dim_diagnostic` `d` ON `d`.`sk_diagnostic` = `m`.`sk_diagnostic`
JOIN (SELECT `mesure_consultation_diagnostic`.`annee`, SUM(`mesure_consultation_diagnostic`.`nbre_consultation`) AS `total_annee`
FROM `chu_dwh`.`mesure_consultation_diagnostic` GROUP BY `mesure_consultation_diagnostic`.`annee`) `t` ON `t`.`annee` = `m`.`annee`
;

-- chu_dwh.v_consultation_etablissement
CREATE VIEW `chu_dwh.v_consultation_etablissement` AS SELECT `m`.`annee`, `e`.`identifiant_organisation`, `e`.`raison_sociale_site`, `e`.`nom_departement`, `e`.`nom_region`,
`m`.`nbre_consultation`, `t`.`total_annee`,
ROUND(100 * `m`.`nbre_consultation` / `t`.`total_annee`, 3) AS `part_pct`
FROM `chu_dwh`.`mesure_consultation_etablissement` `m`
JOIN `chu_dwh`.`dim_etablissement` `e` ON `e`.`sk_etablissement` = `m`.`sk_etablissement`
JOIN (SELECT `mesure_consultation_etablissement`.`annee`, SUM(`mesure_consultation_etablissement`.`nbre_consultation`) AS `total_annee`
FROM `chu_dwh`.`mesure_consultation_etablissement` GROUP BY `mesure_consultation_etablissement`.`annee`) `t` ON `t`.`annee` = `m`.`annee`
;

-- chu_dwh.v_taux_hospitalisation
CREATE VIEW `chu_dwh.v_taux_hospitalisation` AS SELECT `mesure_hospitalisation`.`annee`, `mesure_hospitalisation`.`sexe`, `mesure_hospitalisation`.`tranche_age`, `mesure_hospitalisation`.`nbre_hospitalisation`, `mesure_hospitalisation`.`nbre_patients_hospitalises`,
`mesure_hospitalisation`.`nbre_patients_pris_en_charge`,
ROUND(100 * `mesure_hospitalisation`.`nbre_patients_hospitalises` / `mesure_hospitalisation`.`nbre_patients_pris_en_charge`, 2) AS `taux_pct`
FROM `chu_dwh`.`mesure_hospitalisation`
;
