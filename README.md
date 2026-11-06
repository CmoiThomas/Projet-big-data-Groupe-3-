# Projet CHU – Entrepôt de données décisionnel

Conception et mise en œuvre d'un entrepôt de données Big Data pour un groupement hospitalier. Le projet rassemble des données de santé issues de plusieurs sources afin de produire des indicateurs d'activité fiables, tout en protégeant les données personnelles des patients.

**Équipe :** Thomas CHAMPAVERT, Nizar DINAR, Trystan BOUZON, Samuel HASSINE

## Objectifs

- Centraliser des données de soins dispersées entre une base opérationnelle et des référentiels publics.
- Les nettoyer, les fiabiliser et les organiser pour l'analyse.
- Répondre aux besoins de pilotage du CHU : activité de consultation, hospitalisations, décès et satisfaction des patients.
- Garantir la conformité au RGPD et des temps de réponse adaptés aux tableaux de bord.

## Technologies

Hadoop (HDFS, YARN) · Hive · Talend · PostgreSQL · Power BI

## Démarche

1. **Conception :** modélisation dimensionnelle de l'entrepôt et choix de l'architecture.
2. **Intégration :** chaîne Talend en trois zones (données brutes, nettoyées, prêtes pour l'analyse).
3. **Implémentation physique :** tables Hive optimisées, contrôles de qualité des données.
4. **Évaluation :** banc d'essai pour comparer plusieurs stratégies de stockage et retenir la plus performante.
5. **Restitution :** tableaux de bord Power BI.

## Contenu du dépôt

```
.
├── ddl/        Scripts SQL de création de l'entrepôt
├── talend/     Export du projet Talend
├── bench/      Banc d'essai de performance
│   ├── requetes/
│   └── resultats/
├── analyse/    Requêtes répondant aux besoins métier
├── qualite/    Contrôles de qualité des données
└── README.md
```

- **`ddl/`** : création des bases Hive et des tables de l'entrepôt (dimensions, faits, tables de travail), sous forme de tables externes stockées sur HDFS.
- **`talend/`** : l'ensemble des jobs d'intégration, de l'extraction des sources au chargement de l'entrepôt, ainsi que le job maître qui les orchestre. Les contextes sont fournis sans identifiants.
- **`bench/`** : les scripts qui construisent plusieurs variantes de stockage de l'entrepôt, les requêtes de test, le script qui les exécute et les chronomètre, et les résultats obtenus.
- **`analyse/`** : les vues et les requêtes qui produisent les indicateurs attendus par les utilisateurs (taux de consultation, d'hospitalisation, décès, satisfaction).
- **`qualite/`** : les contrôles de complétude, de doublons, d'intégrité référentielle et de cohérence des identifiants d'établissement, avec leurs résultats.

> Les mots de passe et la clé de pseudonymisation ne sont jamais versionnés : ils sont à renseigner localement.
