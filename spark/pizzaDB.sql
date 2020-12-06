DROP DATABASE IF EXISTS pizzaDB CASCADE;

CREATE DATABASE IF NOT EXISTS pizzaDB;
                          
CREATE TABLE pizzaDB.pizza (
           pizzaID STRING NOT NULL,
           menuName STRING NOT NULL);

CREATE TABLE pizzaDB.restaurant1 (
           pizzaID STRING NOT NULL,
           temp DECIMAL(4,1) NOT NULL,
           timestamp TIMESTAMP NOT NULL);
           
CREATE TABLE pizzaDB.restaurant2 (
           pizzaID STRING NOT NULL,
           temp DECIMAL(4,1) NOT NULL,
           timestamp TIMESTAMP NOT NULL);

INSERT INTO pizzaDB.pizza
VALUES ('PZ123','Margherita'),('PZ456','Margherita'),('PZ789','FourSeasons'),('PZ111','Margherita'),('PZ222','Margherita'),('PZ333','FourSeasons');

INSERT INTO pizzaDB.restaurant1
VALUES ('PZ123',250.5,CAST('2020-12-05 16:24:46.15' AS Timestamp)),
       ('PZ123',255.5,CAST('2020-12-05 16:25:46.15' AS Timestamp)),
       ('PZ123',255.9,CAST('2020-12-05 16:26:46.15' AS Timestamp)),
       ('PZ123',260.0,CAST('2020-12-05 16:27:46.15' AS Timestamp)),
       ('PZ456',280.5,CAST('2020-12-05 16:54:55.15' AS Timestamp)),
       ('PZ456',290.5,CAST('2020-12-05 16:55:55.15' AS Timestamp)),
       ('PZ456',292.2,CAST('2020-12-05 16:56:55.15' AS Timestamp)),
       ('PZ456',291.0,CAST('2020-12-05 16:57:55.15' AS Timestamp)),
       ('PZ789',270.5,CAST('2020-12-05 17:38:47.15' AS Timestamp)),
       ('PZ789',280.5,CAST('2020-12-05 17:39:47.15' AS Timestamp));

INSERT INTO pizzaDB.restaurant2
VALUES ('PZ111',290.5,CAST('2020-12-05 16:24:46.15' AS Timestamp)),
       ('PZ111',289.5,CAST('2020-12-05 16:25:46.15' AS Timestamp)),
       ('PZ111',288.9,CAST('2020-12-05 16:26:46.15' AS Timestamp)),
       ('PZ111',292.0,CAST('2020-12-05 16:27:46.15' AS Timestamp)),
       ('PZ222',290.5,CAST('2020-12-05 16:28:55.15' AS Timestamp)),
       ('PZ222',290.5,CAST('2020-12-05 16:29:55.15' AS Timestamp)),
       ('PZ222',292.2,CAST('2020-12-05 16:30:55.15' AS Timestamp)),
       ('PZ222',291.0,CAST('2020-12-05 16:31:55.15' AS Timestamp)),
       ('PZ333',275.5,CAST('2020-12-05 17:45:26.15' AS Timestamp)),
       ('PZ333',280.5,CAST('2020-12-05 17:46:26.15' AS Timestamp)),
       ('PZ333',278.5,CAST('2020-12-05 17:47:26.15' AS Timestamp)),
       ('PZ333',277.5,CAST('2020-12-05 17:48:26.15' AS Timestamp));

