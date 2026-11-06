-- Q6 (B6) sur les tables d'agrégats
USE ${hivevar:DB};
SELECT pr.nom_affiche, pr.specialite, m.nbre_consultation,
       ROUND(100 * m.nbre_consultation / t.total, 4) AS part_pct
FROM (SELECT sk_professionnel, nbre_consultation FROM mesure_consultation_professionnel WHERE annee = 2020
      ORDER BY nbre_consultation DESC LIMIT 10) m
JOIN dim_professionnel pr ON pr.sk_professionnel = m.sk_professionnel
CROSS JOIN (SELECT SUM(nbre_consultation) AS total FROM mesure_consultation_professionnel WHERE annee = 2020) t
ORDER BY nbre_consultation DESC LIMIT 10;
