-- Q6 (B6) Part des consultations par professionnel en 2020 (10 premiers)
USE ${hivevar:DB};
SELECT pr.nom_affiche, pr.specialite, c.nb AS nbre_consultation,
       ROUND(100 * c.nb / t.total, 4) AS part_pct
FROM (SELECT sk_professionnel, COUNT(*) AS nb FROM fait_consultation
      WHERE annee = 2020 GROUP BY sk_professionnel) c
JOIN dim_professionnel pr ON pr.sk_professionnel = c.sk_professionnel
CROSS JOIN (SELECT COUNT(*) AS total FROM fait_consultation WHERE annee = 2020) t
ORDER BY nbre_consultation DESC LIMIT 10;
