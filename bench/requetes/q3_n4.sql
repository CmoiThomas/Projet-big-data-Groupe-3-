-- Q3 (B3) sur les tables d'agrégats
USE ${hivevar:DB};
SELECT nbre_patients_hospitalises, nbre_patients_pris_en_charge,
       ROUND(100 * nbre_patients_hospitalises / nbre_patients_pris_en_charge, 2) AS taux_pct
FROM mesure_hospitalisation
WHERE annee = 2019 AND sexe = 'TOUS';
