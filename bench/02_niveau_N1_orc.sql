-- Niveau N1 : même copie mais en ORC (seul le format change par rapport à N0).
-- DISTRIBUTE BY répartit l'écriture sur 8 reducers, sinon un seul reducer
-- écrit toute la table et manque de mémoire (même problème que sur J32).

SET mapreduce.job.reduces=8;
CREATE DATABASE IF NOT EXISTS chu_n1 COMMENT 'Benchmark N1 : ORC sans partition' LOCATION '/chu/bench/n1';
USE chu_n1;

DROP TABLE IF EXISTS dim_temps;          CREATE TABLE dim_temps          STORED AS ORC AS SELECT * FROM chu_dwh.dim_temps;
DROP TABLE IF EXISTS dim_localisation;   CREATE TABLE dim_localisation   STORED AS ORC AS SELECT * FROM chu_dwh.dim_localisation;
DROP TABLE IF EXISTS dim_etablissement;  CREATE TABLE dim_etablissement  STORED AS ORC AS SELECT * FROM chu_dwh.dim_etablissement DISTRIBUTE BY sk_etablissement;
DROP TABLE IF EXISTS dim_patient;        CREATE TABLE dim_patient        STORED AS ORC AS SELECT * FROM chu_dwh.dim_patient;
DROP TABLE IF EXISTS dim_professionnel;  CREATE TABLE dim_professionnel  STORED AS ORC AS SELECT * FROM chu_dwh.dim_professionnel DISTRIBUTE BY sk_professionnel;
DROP TABLE IF EXISTS dim_diagnostic;     CREATE TABLE dim_diagnostic     STORED AS ORC AS SELECT * FROM chu_dwh.dim_diagnostic;
DROP TABLE IF EXISTS fait_consultation;    CREATE TABLE fait_consultation    STORED AS ORC AS SELECT * FROM chu_dwh.fait_consultation DISTRIBUTE BY num_consultation;
DROP TABLE IF EXISTS fait_hospitalisation; CREATE TABLE fait_hospitalisation STORED AS ORC AS SELECT * FROM chu_dwh.fait_hospitalisation;
DROP TABLE IF EXISTS fait_deces;           CREATE TABLE fait_deces           STORED AS ORC AS SELECT * FROM chu_dwh.fait_deces DISTRIBUTE BY id_deces;
DROP TABLE IF EXISTS fait_satisfaction;    CREATE TABLE fait_satisfaction    STORED AS ORC AS SELECT * FROM chu_dwh.fait_satisfaction;

SET mapreduce.job.reduces=-1;

-- Contrôle : mêmes volumes que dans chu_dwh
SELECT 'fait_consultation', COUNT(*) FROM fait_consultation
UNION ALL SELECT 'fait_deces', COUNT(*) FROM fait_deces
UNION ALL SELECT 'dim_professionnel', COUNT(*) FROM dim_professionnel;
