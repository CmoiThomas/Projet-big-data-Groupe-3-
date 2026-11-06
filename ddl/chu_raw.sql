-- DDL de la base chu_raw
-- Généré depuis le metastore Hive (SHOW CREATE TABLE).
CREATE DATABASE IF NOT EXISTS chu_raw;

-- chu_raw.activite_pro
CREATE EXTERNAL TABLE `chu_raw.activite_pro`(
  `identifiant` string, 
  `identifiant_organisation` string, 
  `mode_exercice` string)
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
  '/chu/raw/fichiers/activite_pro'
;

-- chu_raw.cog_commune
CREATE EXTERNAL TABLE `chu_raw.cog_commune`(
  `typecom` string, 
  `com` string, 
  `reg` string, 
  `dep` string, 
  `libelle` string, 
  `comparent` string)
PARTITIONED BY ( 
  `millesime` string)
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
  '/chu/raw/referentiels/cog_commune'
;

-- chu_raw.cog_departement
CREATE EXTERNAL TABLE `chu_raw.cog_departement`(
  `dep` string, 
  `reg` string, 
  `libelle` string)
PARTITIONED BY ( 
  `millesime` string)
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
  '/chu/raw/referentiels/cog_departement'
;

-- chu_raw.cog_region
CREATE EXTERNAL TABLE `chu_raw.cog_region`(
  `reg` string, 
  `libelle` string)
PARTITIONED BY ( 
  `millesime` string)
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
  '/chu/raw/referentiels/cog_region'
;

-- chu_raw.consultation
CREATE EXTERNAL TABLE `chu_raw.consultation`(
  `num_consultation` string, 
  `id_patient` string, 
  `id_prof_sante` string, 
  `code_diag` string, 
  `date_consultation` string)
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
  '/chu/raw/postgres/consultation'
;

-- chu_raw.deces
CREATE EXTERNAL TABLE `chu_raw.deces`(
  `sexe` string, 
  `date_naissance` string, 
  `date_deces` string, 
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
  '/chu/raw/opendata/deces'
;

-- chu_raw.diagnostic
CREATE EXTERNAL TABLE `chu_raw.diagnostic`(
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
  '/chu/raw/postgres/diagnostic'
;

-- chu_raw.etablissement
CREATE EXTERNAL TABLE `chu_raw.etablissement`(
  `identifiant_organisation` string, 
  `finess_site` string, 
  `finess_etablissement_juridique` string, 
  `raison_sociale_site` string, 
  `code_commune` string, 
  `code_postal` string, 
  `commune` string)
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
  '/chu/raw/fichiers/etablissement'
;

-- chu_raw.hospitalisation
CREATE EXTERNAL TABLE `chu_raw.hospitalisation`(
  `num_hospitalisation` string, 
  `id_patient` string, 
  `identifiant_organisation` string, 
  `code_diagnostic` string, 
  `libelle_diagnostic` string, 
  `date_entree` string, 
  `jour_hospitalisation` string)
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
  '/chu/raw/fichiers/hospitalisation'
;

-- chu_raw.patient
CREATE EXTERNAL TABLE `chu_raw.patient`(
  `id_patient` string, 
  `sexe` string, 
  `date_naissance` string)
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
  '/chu/raw/postgres/patient'
;

-- chu_raw.professionnel
CREATE EXTERNAL TABLE `chu_raw.professionnel`(
  `identifiant` string, 
  `civilite` string, 
  `categorie_professionnelle` string, 
  `nom` string, 
  `prenom` string, 
  `profession` string, 
  `type_identifiant` string, 
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
  '/chu/raw/postgres/professionnel'
;

-- chu_raw.satisfaction
CREATE EXTERNAL TABLE `chu_raw.satisfaction`(
  `annee` string, 
  `finess` string, 
  `finess_geo` string, 
  `region` string, 
  `nb_repondants` string, 
  `score` string, 
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
  '/chu/raw/opendata/satisfaction'
;

-- chu_raw.specialite
CREATE EXTERNAL TABLE `chu_raw.specialite`(
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
  '/chu/raw/postgres/specialite'
;
