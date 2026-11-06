-- Requêtes d'analyse pour les besoins B1 à B8.
-- S'appuie sur les tables d'agrégats, à lancer après 04_niveau_N4_agregats.sql :
--   beeline -u jdbc:hive2://localhost:10000 -n cloudera -i reglages_session.sql -f 05_requetes_analyse.sql

USE chu_dwh;
-- Vues : une mesure avec ses libellés et son taux, pour ne pas réécrire
-- les jointures dans chaque requête.
DROP VIEW IF EXISTS v_consultation_etablissement;
CREATE VIEW v_consultation_etablissement AS
SELECT m.annee, e.identifiant_organisation, e.raison_sociale_site, e.nom_departement, e.nom_region,
       m.nbre_consultation, t.total_annee,
       ROUND(100 * m.nbre_consultation / t.total_annee, 3) AS part_pct
FROM mesure_consultation_etablissement m
JOIN dim_etablissement e ON e.sk_etablissement = m.sk_etablissement
JOIN (SELECT annee, SUM(nbre_consultation) AS total_annee
      FROM mesure_consultation_etablissement GROUP BY annee) t ON t.annee = m.annee;

DROP VIEW IF EXISTS v_consultation_diagnostic;
CREATE VIEW v_consultation_diagnostic AS
SELECT m.annee, d.code_diag, d.libelle, d.code_categorie, d.chapitre_cim10,
       m.nbre_consultation, t.total_annee,
       ROUND(100 * m.nbre_consultation / t.total_annee, 3) AS part_pct
FROM mesure_consultation_diagnostic m
JOIN dim_diagnostic d ON d.sk_diagnostic = m.sk_diagnostic
JOIN (SELECT annee, SUM(nbre_consultation) AS total_annee
      FROM mesure_consultation_diagnostic GROUP BY annee) t ON t.annee = m.annee;

DROP VIEW IF EXISTS v_taux_hospitalisation;
CREATE VIEW v_taux_hospitalisation AS
SELECT annee, sexe, tranche_age, nbre_hospitalisation, nbre_patients_hospitalises,
       nbre_patients_pris_en_charge,
       ROUND(100 * nbre_patients_hospitalises / nbre_patients_pris_en_charge, 2) AS taux_pct
FROM mesure_hospitalisation;
-- B1 : taux de consultation de l'établissement X sur la période Y
--      (exemple : CH de Fleyriat, 2017 à 2020)
SELECT annee, raison_sociale_site, nbre_consultation, total_annee, part_pct
FROM v_consultation_etablissement
WHERE identifiant_organisation = 'F010000024' AND annee BETWEEN 2017 AND 2020
ORDER BY annee;

-- B1 bis : les 10 établissements les plus consultés en 2020
SELECT raison_sociale_site, nom_region, nbre_consultation, part_pct
FROM v_consultation_etablissement
WHERE annee = 2020 AND identifiant_organisation <> 'INCONNU'
ORDER BY nbre_consultation DESC LIMIT 10;
-- B2 : taux de consultation pour le diagnostic X sur la période Y
--      (exemple : chapitre J, maladies de l'appareil respiratoire, par année)
SELECT annee, SUM(nbre_consultation) AS nbre_consultation, MAX(total_annee) AS total_annee,
       ROUND(100 * SUM(nbre_consultation) / MAX(total_annee), 2) AS part_pct
FROM v_consultation_diagnostic
WHERE chapitre_cim10 = 'J'
GROUP BY annee ORDER BY annee;

-- B2 bis : les 10 diagnostics les plus fréquents en 2019
SELECT code_diag, libelle, nbre_consultation, part_pct
FROM v_consultation_diagnostic WHERE annee = 2019
ORDER BY nbre_consultation DESC LIMIT 10;
-- B3 : taux global d'hospitalisation par année
SELECT annee, nbre_patients_hospitalises, nbre_patients_pris_en_charge, taux_pct
FROM v_taux_hospitalisation WHERE sexe = 'TOUS'
ORDER BY annee;
-- B4 : taux d'hospitalisation par diagnostic (10 diagnostics les plus
--      hospitalisés, toutes années)
SELECT d.code_diag, d.libelle, m.nbre_hospitalisation, m.nbre_patients_hospitalises,
       m.nbre_patients_diagnostic,
       ROUND(100 * m.nbre_patients_hospitalises / m.nbre_patients_diagnostic, 2) AS taux_pct
FROM mesure_hospitalisation_diagnostic m
JOIN dim_diagnostic d ON d.sk_diagnostic = m.sk_diagnostic
ORDER BY m.nbre_hospitalisation DESC LIMIT 10;
-- B5 : taux d'hospitalisation par sexe et par tranche d'âge (2019)
SELECT sexe, tranche_age, nbre_patients_hospitalises, nbre_patients_pris_en_charge, taux_pct
FROM v_taux_hospitalisation WHERE annee = 2019 AND sexe <> 'TOUS'
ORDER BY sexe, tranche_age;
-- B6 : taux de consultation par professionnel (2020), puis par spécialité
SELECT pr.nom_affiche, pr.specialite, pr.etab_principal_nom, m.nbre_consultation,
       ROUND(100 * m.nbre_consultation / t.total, 4) AS part_pct
FROM (SELECT sk_professionnel, nbre_consultation FROM mesure_consultation_professionnel
      WHERE annee = 2020 ORDER BY nbre_consultation DESC LIMIT 10) m
JOIN dim_professionnel pr ON pr.sk_professionnel = m.sk_professionnel
CROSS JOIN (SELECT SUM(nbre_consultation) AS total FROM mesure_consultation_professionnel WHERE annee = 2020) t
ORDER BY m.nbre_consultation DESC;

SELECT pr.specialite, SUM(m.nbre_consultation) AS nbre_consultation,
       ROUND(100 * SUM(m.nbre_consultation) / MAX(t.total), 2) AS part_pct
FROM mesure_consultation_professionnel m
JOIN dim_professionnel pr ON pr.sk_professionnel = m.sk_professionnel
CROSS JOIN (SELECT SUM(nbre_consultation) AS total FROM mesure_consultation_professionnel WHERE annee = 2020) t
WHERE m.annee = 2020
GROUP BY pr.specialite
ORDER BY nbre_consultation DESC LIMIT 15;
-- B7 : nombre de décès par région en 2019 (et par sexe)
SELECT nom_region, SUM(nbre_deces) AS nbre_deces
FROM mesure_deces WHERE annee = 2019
GROUP BY nom_region ORDER BY nbre_deces DESC;

SELECT nom_region, sexe, SUM(nbre_deces) AS nbre_deces
FROM mesure_deces WHERE annee = 2019 AND nom_region NOT IN ('INCONNU', 'ETRANGER')
GROUP BY nom_region, sexe ORDER BY nom_region, sexe;
-- B8 : taux global de satisfaction par région en 2020
SELECT nom_region, nbre_etablissements, nbre_etablissements_classes, total_repondants,
       score_moyen_pondere
FROM mesure_satisfaction WHERE annee = 2020
ORDER BY score_moyen_pondere DESC;
