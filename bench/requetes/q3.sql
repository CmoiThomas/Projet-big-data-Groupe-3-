-- Q3 (B3) Taux global d'hospitalisation en 2019
-- patients distincts hospitalisés / patients distincts pris en charge
USE ${hivevar:DB};
SELECT h.nb_hosp AS patients_hospitalises, p.nb_pec AS patients_pris_en_charge,
       ROUND(100 * h.nb_hosp / p.nb_pec, 2) AS taux_pct
FROM (SELECT COUNT(DISTINCT sk_patient) AS nb_hosp FROM fait_hospitalisation WHERE annee = 2019) h
CROSS JOIN (
  SELECT COUNT(DISTINCT u.sk_patient) AS nb_pec
  FROM (SELECT sk_patient FROM fait_consultation WHERE annee = 2019
        UNION ALL
        SELECT sk_patient FROM fait_hospitalisation WHERE annee = 2019) u
) p;
