-- Niveau N4 : tables d'agrégats dans chu_dwh (/chu/dwh/mesures).
-- Calculées à partir des faits, une fois les clés étrangères résolues :
-- nbre_consultation, nbre_hospitalisation, nbre_deces, total_satisfaction.
-- Chaque table est au grain d'une analyse, les requêtes lisent quelques
-- centaines de lignes au lieu de plusieurs millions.
-- TODO : intégrer ce script dans la chaîne Talend (job J44, après J04).

USE chu_dwh;
-- nbre_consultation, selon trois axes (B1, B2, B6)
CREATE EXTERNAL TABLE IF NOT EXISTS mesure_consultation_etablissement (
  annee INT, sk_etablissement INT, nbre_consultation BIGINT)
STORED AS ORC LOCATION '/chu/dwh/mesures/consultation_etablissement';
INSERT OVERWRITE TABLE mesure_consultation_etablissement
SELECT annee, sk_etablissement, SUM(nb) FROM fait_consultation GROUP BY annee, sk_etablissement;

CREATE EXTERNAL TABLE IF NOT EXISTS mesure_consultation_diagnostic (
  annee INT, sk_diagnostic INT, nbre_consultation BIGINT)
STORED AS ORC LOCATION '/chu/dwh/mesures/consultation_diagnostic';
INSERT OVERWRITE TABLE mesure_consultation_diagnostic
SELECT annee, sk_diagnostic, SUM(nb) FROM fait_consultation GROUP BY annee, sk_diagnostic;

CREATE EXTERNAL TABLE IF NOT EXISTS mesure_consultation_professionnel (
  annee INT, sk_professionnel INT, nbre_consultation BIGINT)
STORED AS ORC LOCATION '/chu/dwh/mesures/consultation_professionnel';
INSERT OVERWRITE TABLE mesure_consultation_professionnel
SELECT annee, sk_professionnel, SUM(nb) FROM fait_consultation GROUP BY annee, sk_professionnel;
-- nbre_hospitalisation et patients distincts par année, sexe et tranche
-- d'âge (B3, B5). Les lignes sexe = 'TOUS' / tranche = 'TOUTES' portent le
-- total de l'année : un nombre de patients distincts ne s'additionne pas
-- entre groupes, il faut donc le précalculer à part.
CREATE EXTERNAL TABLE IF NOT EXISTS mesure_hospitalisation (
  annee INT, sexe STRING, tranche_age STRING, nbre_hospitalisation BIGINT,
  nbre_patients_hospitalises BIGINT, nbre_patients_pris_en_charge BIGINT)
STORED AS ORC LOCATION '/chu/dwh/mesures/hospitalisation';

INSERT OVERWRITE TABLE mesure_hospitalisation
SELECT g.annee, g.sexe, g.tranche_age, COALESCE(h.nbre_hosp, 0), COALESCE(h.nb_pat_h, 0), g.nb_pec
FROM (
  SELECT u.annee, p.sexe, u.tranche_age, COUNT(DISTINCT u.sk_patient) AS nb_pec
  FROM (SELECT annee, sk_patient, tranche_age FROM fait_consultation
        UNION ALL
        SELECT annee, sk_patient, tranche_age FROM fait_hospitalisation) u
  JOIN dim_patient p ON p.sk_patient = u.sk_patient
  GROUP BY u.annee, p.sexe, u.tranche_age
) g
LEFT JOIN (
  SELECT f.annee, p.sexe, f.tranche_age, SUM(f.nb) AS nbre_hosp, COUNT(DISTINCT f.sk_patient) AS nb_pat_h
  FROM fait_hospitalisation f JOIN dim_patient p ON p.sk_patient = f.sk_patient
  GROUP BY f.annee, p.sexe, f.tranche_age
) h ON h.annee = g.annee AND h.sexe = g.sexe AND h.tranche_age = g.tranche_age;

INSERT INTO TABLE mesure_hospitalisation
SELECT g.annee, 'TOUS', 'TOUTES', COALESCE(h.nbre_hosp, 0), COALESCE(h.nb_pat_h, 0), g.nb_pec
FROM (
  SELECT u.annee, COUNT(DISTINCT u.sk_patient) AS nb_pec
  FROM (SELECT annee, sk_patient FROM fait_consultation
        UNION ALL
        SELECT annee, sk_patient FROM fait_hospitalisation) u
  GROUP BY u.annee
) g
LEFT JOIN (
  SELECT annee, SUM(nb) AS nbre_hosp, COUNT(DISTINCT sk_patient) AS nb_pat_h
  FROM fait_hospitalisation GROUP BY annee
) h ON h.annee = g.annee;
-- nbre_hospitalisation par diagnostic, toutes années (B4)
CREATE EXTERNAL TABLE IF NOT EXISTS mesure_hospitalisation_diagnostic (
  sk_diagnostic INT, nbre_hospitalisation BIGINT, nbre_patients_hospitalises BIGINT,
  nbre_patients_diagnostic BIGINT)
STORED AS ORC LOCATION '/chu/dwh/mesures/hospitalisation_diagnostic';
INSERT OVERWRITE TABLE mesure_hospitalisation_diagnostic
SELECT h.sk_diagnostic, h.nbre_hosp, h.nb_pat_h, p.nb_pat
FROM (SELECT sk_diagnostic, SUM(nb) AS nbre_hosp, COUNT(DISTINCT sk_patient) AS nb_pat_h
      FROM fait_hospitalisation GROUP BY sk_diagnostic) h
JOIN (SELECT u.sk_diagnostic, COUNT(DISTINCT u.sk_patient) AS nb_pat
      FROM (SELECT sk_diagnostic, sk_patient FROM fait_consultation
            UNION ALL
            SELECT sk_diagnostic, sk_patient FROM fait_hospitalisation) u
      GROUP BY u.sk_diagnostic) p ON p.sk_diagnostic = h.sk_diagnostic;
-- nbre_deces par année, région, sexe et tranche d'âge (B7)
CREATE EXTERNAL TABLE IF NOT EXISTS mesure_deces (
  annee INT, nom_region STRING, sexe STRING, tranche_age STRING, nbre_deces BIGINT)
STORED AS ORC LOCATION '/chu/dwh/mesures/deces';
INSERT OVERWRITE TABLE mesure_deces
SELECT f.annee, l.nom_region, f.sexe, f.tranche_age, SUM(f.nb)
FROM fait_deces f JOIN dim_localisation l ON l.sk_localisation = f.sk_localisation
GROUP BY f.annee, l.nom_region, f.sexe, f.tranche_age;
-- total_satisfaction par année et région (B8)
-- total_satisfaction = somme des scores pondérés par les répondants ;
-- score_moyen_pondere = total_satisfaction / total_repondants
CREATE EXTERNAL TABLE IF NOT EXISTS mesure_satisfaction (
  annee INT, nom_region STRING, nbre_etablissements BIGINT, nbre_etablissements_classes BIGINT,
  total_repondants BIGINT, total_satisfaction DOUBLE, score_moyen_pondere DOUBLE)
STORED AS ORC LOCATION '/chu/dwh/mesures/satisfaction';
INSERT OVERWRITE TABLE mesure_satisfaction
SELECT f.annee, l.nom_region, COUNT(*),
       SUM(CASE WHEN f.est_classe THEN 1 ELSE 0 END),
       SUM(CASE WHEN f.score IS NOT NULL THEN f.nb_repondants ELSE 0 END),
       SUM(CASE WHEN f.score IS NOT NULL THEN f.score * f.nb_repondants ELSE 0 END),
       ROUND(SUM(CASE WHEN f.score IS NOT NULL THEN f.score * f.nb_repondants ELSE 0 END)
             / SUM(CASE WHEN f.score IS NOT NULL THEN f.nb_repondants ELSE 0 END), 2)
FROM fait_satisfaction f JOIN dim_localisation l ON l.sk_localisation = f.sk_localisation
GROUP BY f.annee, l.nom_region;

-- Contrôles : les totaux doivent égaler ceux des faits
SELECT 'consultations', SUM(nbre_consultation) FROM mesure_consultation_etablissement
UNION ALL SELECT 'hospitalisations', SUM(nbre_hospitalisation) FROM mesure_hospitalisation WHERE sexe = 'TOUS'
UNION ALL SELECT 'deces', SUM(nbre_deces) FROM mesure_deces
UNION ALL SELECT 'satisfaction (lignes)', SUM(nbre_etablissements) FROM mesure_satisfaction;
