# Projet NYC Taxi & Limousine Commission

Ce projet rentre dans le cadre d'une formation data engineer et a pour but d'expérimenter les outils snowflake et dbt.  
  
Les données proviennent de [NYC Taxi & Limousine Commission](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page). Le périmètre est les taxis jaunes depuis janvier 2024.

## Prérequis

J'ai choisi d'utiliser dbt-core. De ce fait, python est requis.  
J'ai souscrit à l'offre d'essai de 30 jours de Snowflake.  

## Démarrage du projet

Dans Snowflake, créer le datawrehouse, la base, le rôle, l'utilsateur avec le script *DBTCore_archi.sql*.
J'ai fait l'ingestion des fichiers manuellement dans la table raw.

Pour la suite dans VSCode, j'ai utlisé uv comme gestionnaire de package, les commandes sont donc toutes précédées de *uv run*.  

Initialisation de uv:  
uv init  

Ajout des package dbt:  
uv add dbt-snowflake  
uv add dbt-core  

Initialisation du projet dbt:  
uv run dbt init  

    Enter a name for your project (letters, digits, underscore) : nyc_taxi_project  
    Enter a number : 1 (1 :snowflake)
    account (https://<this_value>.snowflakecomputing.com): WQROSHC-WB67786
    user (dev username): nyc_taxi_driver
    Desired authentication type option (enter a number): 1 (1:password)
    password (dev password): 
    role (dev role): taxi_driver
    warehouse (warehouse name): NYC_TAXI_WH
    database (default database that dbt will build objects in): NYC_TAXI_DB
    schema (default schema that dbt will build objects in): RAW
    threads (1 or more) [1]: 10  

Il faut ensuite créer les différents *models*. Pour cela, on crée un répertoire par *model*, soit:  

    models/staging
    models/intermediate
    models/marts

A noter que les schémas Snowflake sont eux:

    raw
    staging
    final

Dans le dossier *models* se trouvent les fichiers de configuration .yml pour les sources ainsi que les schémas pour les tables (descriptions, tests unitaires, ...) et les scripts .sql pour les alimentations de tables ou vues.

Deux autres fichiers sont créés:

    macros\generate_schema_name.sql qui permet d'enlever le préfixe par défaut
    packages.yml à la racine du projet → renseigner les packages qui servent entre autre pour les tests.

Pour les installer, *uv run dbt deps*

## Exécution du projet

Le projet s'exécute ainsi:  

    uv run dbt run

DBT permet de générer la documentation automatiquement avec les commandes:  
*uv run dbt docs generate* et *uv run dbt docs serve* pour un affichage web en local.

## Visualisation

J'ai fait la visualisation avec Power BI (NYC.pbix), des captures d'écrans sont visibles dans NYC_screeshots.odp 
