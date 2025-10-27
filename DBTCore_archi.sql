-- Utiliser le rôle admin
USE ROLE accountadmin;

-- Créer le warehouse par défaut
CREATE WAREHOUSE IF NOT EXISTS NYC_TAXI_WH 
    WITH warehouse_size='medium'
    auto_suspend= 60;

GRANT OPERATE ON WAREHOUSE NYC_TAXI_WH TO ROLE taxi_driver;

-- Création de la BDD et du schéma
CREATE DATABASE IF NOT EXISTS NYC_TAXI_DB;
CREATE SCHEMA IF NOT EXISTS NYC_TAXI_DB.RAW;

-- Créer le rôle `taxi_driver`
CREATE ROLE IF NOT EXISTS taxi_driver;

-- Donner les permissions au rôle 'taxi_driver' sur le warehouse et l'ensemble de la database
GRANT ALL ON WAREHOUSE NYC_TAXI_WH TO ROLE taxi_driver;
GRANT ALL ON DATABASE NYC_TAXI_DB to ROLE taxi_driver;
GRANT ALL ON ALL SCHEMAS IN DATABASE NYC_TAXI_DB to ROLE taxi_driver;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE NYC_TAXI_DB to ROLE taxi_driver;
GRANT ALL ON ALL TABLES IN SCHEMA NYC_TAXI_DB.RAW to ROLE taxi_driver;
GRANT ALL ON FUTURE TABLES IN SCHEMA NYC_TAXI_DB.RAW to ROLE taxi_driver;

-- Créer l'utilisateur nyc_taxi_driver et lui assigner le rôle
CREATE USER IF NOT EXISTS nyc_taxi_driver
  PASSWORD='MotDePasseDBT123@'
  LOGIN_NAME='nyc_taxi_driver'
  MUST_CHANGE_PASSWORD=FALSE
  DEFAULT_WAREHOUSE='NYC_TAXI_WH'
  DEFAULT_ROLE='taxi_driver'
  DEFAULT_NAMESPACE='NYC_TAXI_DB.RAW'
  COMMENT='Utilisateur taxi_driver pour la transformation des données';

GRANT ROLE taxi_driver to USER nyc_taxi_driver;

USE ROLE taxi_driver;