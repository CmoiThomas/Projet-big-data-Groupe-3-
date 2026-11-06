-- Réglages Hive communs à toutes les sessions du benchmark
-- (création des niveaux et mesures), pour comparer les niveaux à l'identique.

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
-- Bucketing : Hive crée exactement N fichiers par partition
SET hive.enforce.bucketing=true;
-- Jointure par buckets quand les deux tables sont bucketées sur la même clé
SET hive.optimize.bucketmapjoin=true;
-- Blocs ORC de 16 Mo au lieu de 64 Mo (mémoire des tâches limitée sur la VM)
SET hive.exec.orc.default.stripe.size=16777216;
-- Jointures en mémoire limitées aux petites tables (< 2 Mo) : évite le code 137
SET hive.auto.convert.join.noconditionaltask.size=2000000;
SET hive.mapjoin.smalltable.filesize=2000000;
-- Nombre de tâches reduce estimé par Hive (valeur par défaut)
SET mapreduce.job.reduces=-1;
-- Prépare les jointures en mémoire dans HiveServer2 au lieu d'une JVM séparée
-- (la JVM fille ne démarre pas sur la VM : erreur MapredLocalTask code 1)
SET hive.exec.submit.local.task.via.child=false;
