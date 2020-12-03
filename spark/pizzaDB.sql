DROP DATABASE IF EXISTS pizzaDB CASCADE;

CREATE DATABASE IF NOT EXISTS pizzaDB;
                          
CREATE TABLE pizzaDB.pizza (
           pizzaID STRING NOT NULL,
           menuName STRING NOT NULL);

CREATE TABLE pizzaDB.measures (
           pizzaID STRING NOT NULL,
           value DECIMAL(4,1) NOT NULL);

INSERT INTO pizzaDB.pizza
VALUES ('PZ123','Margherita'),('PZ222','Margherita'),('PZ333','FourSeasons'),('PZ444','Margherita'),('PZ456','Margherita'),('PZ789','FourSeasons');

INSERT INTO pizzaDB.measures
VALUES ('PZ123',250.5),('PZ222',273.0),('PZ333',380.0),('PZ333',10.0),('PZ333',20.0),('PZ444',254.7),('PZ456',270.2),('PZ789',260.9);






























