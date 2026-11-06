-- Niveau N0 : copie de l'entrepôt en texte brut, sans partition ni bucket.
-- Sert de référence pour le benchmark.

CREATE DATABASE IF NOT EXISTS chu_n0 COMMENT 'Benchmark N0 : texte brut' LOCATION '/chu/bench/n0';
USE chu_n0;

DROP TABLE IF EXISTS dim_temps;          CREATE TABLE dim_temps          STORED AS TEXTFILE AS SELECT * FROM chu_dwh.dim_temps;
DROP TABLE IF EXISTS dim_localisation;   CREATE TABLE dim_localisation   STORED AS TEXTFILE AS SELECT * FROM chu_dwh.dim_localisation;
DROP TABLE IF EXISTS dim_etablissement;  CREATE TABLE dim_etablissement  STORED AS TEXTFILE AS SELECT * FROM chu_dwh.dim_etablissement;
DROP TABLE IF EXISTS dim_patient;        CREATE TABLE dim_patient        STORED AS TEXTFILE AS SELECT * FROM chu_dwh.dim_patient;
DROP TABLE IF EXISTS dim_professionnel;  CREATE TABLE dim_professionnel  STORED AS TEXTFILE AS SELECT * FROM chu_dwh.dim_professionnel;
DROP TABLE IF EXISTS dim_diagnostic;     CREATE TABLE dim_diagnostic     STORED AS TEXTFILE AS SELECT * FROM chu_dwh.dim_diagnostic;
-- Les faits Gold sont partitionnés par année : SELECT * renvoie la colonne
-- annee en dernière position, qui devient ici une colonne ordinaire.
DROP TABLE IF EXISTS fait_consultation;    CREATE TABLE fait_consultation    STORED AS TEXTFILE AS SELECT * FROM chu_dwh.fait_consultation;
DROP TABLE IF EXISTS fait_hospitalisation; CREATE TABLE fait_hospitalisation STORED AS TEXTFILE AS SELECT * FROM chu_dwh.fait_hospitalisation;
DROP TABLE IF EXISTS fait_deces;           CREATE TABLE fait_deces           STORED AS TEXTFILE AS SELECT * FROM chu_dwh.fait_deces;
DROP TABLE IF EXISTS fait_satisfaction;    CREATE TABLE fait_satisfaction    STORED AS TEXTFILE AS SELECT * FROM chu_dwh.fait_satisfaction;

-- Contrôle : mêmes volumes que Gold
SELECT 'fait_consultation', COUNT(*) FROM fait_consultation
UNION ALL SELECT 'fait_deces', COUNT(*) FROM fait_deces
UNION ALL SELECT 'dim_professionnel', COUNT(*) FROM dim_professionnel;
