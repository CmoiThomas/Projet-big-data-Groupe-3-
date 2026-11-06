-- Contrôles de qualité des données :
--   1. complétude des attributs (Silver)
--   2. résolution des clés étrangères (Gold)
--   3. doublons
--   4. intégrité référentielle (Gold)
--   5. cohérence des codes FINESS
-- Les taux sont en % de lignes renseignées (ni NULL ni chaîne vide).
-- Lancer avec --force=true pour que beeline continue si un contrôle échoue.

USE chu_staging;
-- 1. Complétude par attribut (couche Silver, chargement du 2026-10-28)
SELECT 'patient_pseudo' AS table_silver, COUNT(*) AS lignes,
  ROUND(100 * AVG(CASE WHEN id_patient_pseudo <> '' THEN 1 ELSE 0 END), 2) AS id_patient_pseudo,
  ROUND(100 * AVG(CASE WHEN sexe IN ('M', 'F') THEN 1 ELSE 0 END), 2) AS sexe_connu,
  ROUND(100 * AVG(CASE WHEN date_naissance IS NOT NULL THEN 1 ELSE 0 END), 2) AS date_naissance
FROM patient_pseudo WHERE load_date = '2026-10-28';

SELECT 'consultation' AS table_silver, COUNT(*) AS lignes,
  ROUND(100 * AVG(CASE WHEN num_consultation <> '' THEN 1 ELSE 0 END), 2) AS num_consultation,
  ROUND(100 * AVG(CASE WHEN id_patient_pseudo <> '' THEN 1 ELSE 0 END), 2) AS id_patient_pseudo,
  ROUND(100 * AVG(CASE WHEN id_professionnel <> '' THEN 1 ELSE 0 END), 2) AS id_professionnel,
  ROUND(100 * AVG(CASE WHEN code_diag <> '' THEN 1 ELSE 0 END), 2) AS code_diag,
  ROUND(100 * AVG(CASE WHEN date_consultation IS NOT NULL THEN 1 ELSE 0 END), 2) AS date_consultation
FROM consultation WHERE load_date = '2026-10-28';

SELECT 'hospitalisation' AS table_silver, COUNT(*) AS lignes,
  ROUND(100 * AVG(CASE WHEN id_patient_pseudo <> '' THEN 1 ELSE 0 END), 2) AS id_patient_pseudo,
  ROUND(100 * AVG(CASE WHEN identifiant_organisation <> '' THEN 1 ELSE 0 END), 2) AS identifiant_organisation,
  ROUND(100 * AVG(CASE WHEN code_diag <> '' THEN 1 ELSE 0 END), 2) AS code_diag,
  ROUND(100 * AVG(CASE WHEN libelle_diag <> '' THEN 1 ELSE 0 END), 2) AS libelle_diag,
  ROUND(100 * AVG(CASE WHEN date_entree IS NOT NULL THEN 1 ELSE 0 END), 2) AS date_entree,
  ROUND(100 * AVG(CASE WHEN duree_jours IS NOT NULL THEN 1 ELSE 0 END), 2) AS duree_jours
FROM hospitalisation WHERE load_date = '2026-10-28';

SELECT 'deces' AS table_silver, COUNT(*) AS lignes,
  ROUND(100 * AVG(CASE WHEN sexe IN ('M', 'F') THEN 1 ELSE 0 END), 2) AS sexe_connu,
  ROUND(100 * AVG(CASE WHEN date_naissance IS NOT NULL THEN 1 ELSE 0 END), 2) AS date_naissance,
  ROUND(100 * AVG(CASE WHEN date_deces IS NOT NULL THEN 1 ELSE 0 END), 2) AS date_deces,
  ROUND(100 * AVG(CASE WHEN NOT date_approximative THEN 1 ELSE 0 END), 2) AS date_exacte,
  ROUND(100 * AVG(CASE WHEN age_deces IS NOT NULL THEN 1 ELSE 0 END), 2) AS age_deces,
  ROUND(100 * AVG(CASE WHEN code_lieu_deces <> '' THEN 1 ELSE 0 END), 2) AS code_lieu_deces
FROM deces WHERE load_date = '2026-10-28';

SELECT 'etablissement' AS table_silver, COUNT(*) AS lignes,
  ROUND(100 * AVG(CASE WHEN finess_site <> '' THEN 1 ELSE 0 END), 2) AS finess_site,
  ROUND(100 * AVG(CASE WHEN finess_juridique <> '' THEN 1 ELSE 0 END), 2) AS finess_juridique,
  ROUND(100 * AVG(CASE WHEN raison_sociale <> '' THEN 1 ELSE 0 END), 2) AS raison_sociale,
  ROUND(100 * AVG(CASE WHEN code_commune <> '' THEN 1 ELSE 0 END), 2) AS code_commune,
  ROUND(100 * AVG(CASE WHEN code_departement IS NOT NULL AND code_departement <> '' THEN 1 ELSE 0 END), 2) AS code_departement,
  ROUND(100 * AVG(CASE WHEN code_postal <> '' THEN 1 ELSE 0 END), 2) AS code_postal
FROM etablissement WHERE load_date = '2026-10-28';

SELECT 'professionnel' AS table_silver, COUNT(*) AS lignes,
  ROUND(100 * AVG(CASE WHEN nom <> '' THEN 1 ELSE 0 END), 2) AS nom,
  ROUND(100 * AVG(CASE WHEN profession <> '' THEN 1 ELSE 0 END), 2) AS profession,
  ROUND(100 * AVG(CASE WHEN code_specialite <> '' THEN 1 ELSE 0 END), 2) AS code_specialite,
  ROUND(100 * AVG(CASE WHEN categorie_professionnelle <> '' THEN 1 ELSE 0 END), 2) AS categorie
FROM professionnel WHERE load_date = '2026-10-28';

SELECT 'satisfaction' AS table_silver, COUNT(*) AS lignes,
  ROUND(100 * AVG(CASE WHEN finess_geo <> '' THEN 1 ELSE 0 END), 2) AS finess_geo,
  ROUND(100 * AVG(CASE WHEN score IS NOT NULL THEN 1 ELSE 0 END), 2) AS score,
  ROUND(100 * AVG(CASE WHEN nb_repondants IS NOT NULL THEN 1 ELSE 0 END), 2) AS nb_repondants,
  ROUND(100 * AVG(CASE WHEN region <> '' THEN 1 ELSE 0 END), 2) AS region
FROM satisfaction WHERE load_date = '2026-10-28';
-- 2. Résolution des clés étrangères dans les faits (Gold)
--    % de lignes rattachées à un vrai membre (clé > 0, et non -1/-2)
USE chu_dwh;

SELECT 'fait_consultation' AS fait, COUNT(*) AS lignes,
  ROUND(100 * AVG(CASE WHEN sk_patient > 0 THEN 1 ELSE 0 END), 2) AS patient,
  ROUND(100 * AVG(CASE WHEN sk_professionnel > 0 THEN 1 ELSE 0 END), 2) AS professionnel,
  ROUND(100 * AVG(CASE WHEN sk_diagnostic > 0 THEN 1 ELSE 0 END), 2) AS diagnostic,
  ROUND(100 * AVG(CASE WHEN sk_etablissement > 0 THEN 1 ELSE 0 END), 2) AS etablissement,
  ROUND(100 * AVG(CASE WHEN sk_localisation > 0 THEN 1 ELSE 0 END), 2) AS localisation,
  ROUND(100 * AVG(CASE WHEN age_patient IS NOT NULL THEN 1 ELSE 0 END), 2) AS age
FROM fait_consultation;

SELECT 'fait_hospitalisation' AS fait, COUNT(*) AS lignes,
  ROUND(100 * AVG(CASE WHEN sk_patient > 0 THEN 1 ELSE 0 END), 2) AS patient,
  ROUND(100 * AVG(CASE WHEN sk_diagnostic > 0 THEN 1 ELSE 0 END), 2) AS diagnostic,
  ROUND(100 * AVG(CASE WHEN sk_etablissement > 0 THEN 1 ELSE 0 END), 2) AS etablissement,
  ROUND(100 * AVG(CASE WHEN sk_localisation > 0 THEN 1 ELSE 0 END), 2) AS localisation,
  ROUND(100 * AVG(CASE WHEN age_patient IS NOT NULL THEN 1 ELSE 0 END), 2) AS age
FROM fait_hospitalisation;

SELECT 'fait_deces' AS fait, COUNT(*) AS lignes,
  ROUND(100 * AVG(CASE WHEN sk_localisation > 0 THEN 1 ELSE 0 END), 2) AS localisation_france,
  ROUND(100 * AVG(CASE WHEN sk_localisation = -2 THEN 1 ELSE 0 END), 2) AS etranger,
  ROUND(100 * AVG(CASE WHEN sk_localisation = -1 THEN 1 ELSE 0 END), 2) AS lieu_inconnu,
  ROUND(100 * AVG(CASE WHEN age_deces IS NOT NULL THEN 1 ELSE 0 END), 2) AS age
FROM fait_deces;

SELECT 'fait_satisfaction' AS fait, COUNT(*) AS lignes,
  ROUND(100 * AVG(CASE WHEN sk_etablissement > 0 THEN 1 ELSE 0 END), 2) AS etablissement,
  ROUND(100 * AVG(CASE WHEN sk_localisation > 0 THEN 1 ELSE 0 END), 2) AS region,
  ROUND(100 * AVG(CASE WHEN score IS NOT NULL THEN 1 ELSE 0 END), 2) AS score
FROM fait_satisfaction;
-- 3. Doublons : nombre de lignes moins nombre de clés distinctes
--    (0 attendu partout)
SELECT 'fait_consultation' AS table_, COUNT(*) - COUNT(DISTINCT num_consultation) AS doublons FROM fait_consultation
UNION ALL SELECT 'fait_hospitalisation' AS table_, COUNT(*) - COUNT(DISTINCT num_hospitalisation) AS doublons FROM fait_hospitalisation
UNION ALL SELECT 'fait_deces' AS table_, COUNT(*) - COUNT(DISTINCT id_deces) AS doublons FROM fait_deces
UNION ALL SELECT 'dim_patient' AS table_, COUNT(*) - COUNT(DISTINCT id_patient_pseudo) AS doublons FROM dim_patient
UNION ALL SELECT 'dim_professionnel' AS table_, COUNT(*) - COUNT(DISTINCT id_professionnel_source) AS doublons FROM dim_professionnel
UNION ALL SELECT 'dim_etablissement' AS table_, COUNT(*) - COUNT(DISTINCT identifiant_organisation) AS doublons FROM dim_etablissement
UNION ALL SELECT 'dim_diagnostic' AS table_, COUNT(*) - COUNT(DISTINCT code_diag) AS doublons FROM dim_diagnostic;

-- Doublons retirés par la chaîne (Bronze -> Silver)
SELECT 'deces (empreinte)' AS source_, b.n - s.n AS doublons_retires
FROM (SELECT COUNT(*) AS n FROM chu_raw.deces WHERE load_date = '2026-10-28') b
CROSS JOIN (SELECT COUNT(*) AS n FROM chu_staging.deces WHERE load_date = '2026-10-28') s;
-- 4. Intégrité référentielle : clés des faits absentes des dimensions
--    (0 attendu : toute clé introuvable a été remplacée par -1)
SELECT 'consultation -> patient' AS relation, COUNT(*) AS orphelins
FROM fait_consultation f LEFT JOIN dim_patient d ON d.sk_patient = f.sk_patient WHERE d.sk_patient IS NULL
UNION ALL
SELECT 'consultation -> professionnel' AS relation, COUNT(*) AS orphelins
FROM fait_consultation f LEFT JOIN dim_professionnel d ON d.sk_professionnel = f.sk_professionnel WHERE d.sk_professionnel IS NULL
UNION ALL
SELECT 'consultation -> etablissement' AS relation, COUNT(*) AS orphelins
FROM fait_consultation f LEFT JOIN dim_etablissement d ON d.sk_etablissement = f.sk_etablissement WHERE d.sk_etablissement IS NULL
UNION ALL
SELECT 'consultation -> temps' AS relation, COUNT(*) AS orphelins
FROM fait_consultation f LEFT JOIN dim_temps d ON d.sk_temps = f.sk_temps WHERE d.sk_temps IS NULL
UNION ALL
SELECT 'deces -> localisation' AS relation, COUNT(*) AS orphelins
FROM fait_deces f LEFT JOIN dim_localisation d ON d.sk_localisation = f.sk_localisation WHERE d.sk_localisation IS NULL
UNION ALL
SELECT 'deces -> temps' AS relation, COUNT(*) AS orphelins
FROM fait_deces f LEFT JOIN dim_temps d ON d.sk_temps = f.sk_temps WHERE d.sk_temps IS NULL
UNION ALL
SELECT 'satisfaction -> temps' AS relation, COUNT(*) AS orphelins
FROM fait_satisfaction f LEFT JOIN dim_temps d ON d.sk_temps = f.sk_temps WHERE d.sk_temps IS NULL;
-- 5. Cohérence des codes FINESS
-- 5a. Format : un FINESS compte 9 caractères (chiffres, ou 2A/2B pour la Corse)
SELECT 'finess_site' AS code_, COUNT(*) AS renseignes,
       ROUND(100 * AVG(CASE WHEN finess_site RLIKE '^[0-9][0-9AB][0-9]{7}$' THEN 1 ELSE 0 END), 2) AS format_valide_pct
FROM chu_staging.etablissement WHERE load_date = '2026-10-28' AND finess_site <> ''
UNION ALL
SELECT 'finess_juridique' AS code_, COUNT(*) AS renseignes,
       ROUND(100 * AVG(CASE WHEN finess_juridique RLIKE '^[0-9][0-9AB][0-9]{7}$' THEN 1 ELSE 0 END), 2) AS format_valide_pct
FROM chu_staging.etablissement WHERE load_date = '2026-10-28' AND finess_juridique <> '';

-- 5b. Satisfaction : FINESS géographiques retrouvés dans le référentiel
--     des établissements (identifiant 'F' + FINESS géographique)
SELECT s.annee, COUNT(*) AS lignes,
       SUM(CASE WHEN e.identifiant_organisation IS NOT NULL THEN 1 ELSE 0 END) AS finess_geo_trouves,
       ROUND(100 * AVG(CASE WHEN e.identifiant_organisation IS NOT NULL THEN 1 ELSE 0 END), 2) AS taux_pct
FROM chu_staging.satisfaction s
LEFT JOIN (SELECT identifiant_organisation FROM chu_staging.etablissement WHERE load_date = '2026-10-28') e
  ON e.identifiant_organisation = concat('F', s.finess_geo)
WHERE s.load_date = '2026-10-28'
GROUP BY s.annee ORDER BY s.annee;

-- 5c. Hospitalisations : établissements retrouvés dans le référentiel
SELECT COUNT(*) AS sejours,
       SUM(CASE WHEN e.identifiant_organisation IS NOT NULL THEN 1 ELSE 0 END) AS etablissement_trouve
FROM chu_staging.hospitalisation h
LEFT JOIN (SELECT identifiant_organisation FROM chu_staging.etablissement WHERE load_date = '2026-10-28') e
  ON e.identifiant_organisation = h.identifiant_organisation
WHERE h.load_date = '2026-10-28';

-- 5d. Codes de lieu non retrouvés dans le COG (table de contrôle de J31)
SELECT source, COUNT(*) AS codes_distincts, SUM(nb_lignes) AS lignes
FROM chu_staging.localisation_controle GROUP BY source;
