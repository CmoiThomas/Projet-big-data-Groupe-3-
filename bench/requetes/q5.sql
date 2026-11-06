-- Q5 (B5) Taux d'hospitalisation par sexe et tranche d'âge en 2019
USE ${hivevar:DB};
SELECT g.sexe, g.tranche_age, COALESCE(h.nb_hosp, 0) AS patients_hospitalises,
       g.nb_pec AS patients_pris_en_charge,
       ROUND(100 * COALESCE(h.nb_hosp, 0) / g.nb_pec, 2) AS taux_pct
FROM (SELECT p.sexe, u.tranche_age, COUNT(DISTINCT u.sk_patient) AS nb_pec
      FROM (SELECT sk_patient, tranche_age FROM fait_consultation WHERE annee = 2019
            UNION ALL
            SELECT sk_patient, tranche_age FROM fait_hospitalisation WHERE annee = 2019) u
      JOIN dim_patient p ON p.sk_patient = u.sk_patient
      GROUP BY p.sexe, u.tranche_age) g
LEFT JOIN (SELECT p.sexe, f.tranche_age, COUNT(DISTINCT f.sk_patient) AS nb_hosp
           FROM fait_hospitalisation f JOIN dim_patient p ON p.sk_patient = f.sk_patient
           WHERE f.annee = 2019
           GROUP BY p.sexe, f.tranche_age) h
  ON h.sexe = g.sexe AND h.tranche_age = g.tranche_age
ORDER BY g.sexe, g.tranche_age LIMIT 100;
