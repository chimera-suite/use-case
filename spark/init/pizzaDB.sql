DROP DATABASE IF EXISTS pizzaDB CASCADE;

CREATE DATABASE IF NOT EXISTS pizzaDB;
                          
CREATE TABLE pizzaDB.pizza (
           pizzaID STRING,
           menuName STRING);

CREATE TABLE pizzaDB.restaurant1and3 (
	   restaurantID INTEGER,
           pizzaID STRING,
           temp DECIMAL(4,1),
           timestamp TIMESTAMP);
           
CREATE TABLE pizzaDB.restaurant2 (
           pizzaID STRING,
           temp DECIMAL(4,1),
           timestamp TIMESTAMP);

CREATE TABLE pizzaDB.analysis (
           pizzaID STRING,
           outcome STRING);

INSERT INTO pizzaDB.pizza
VALUES ('PZ123','Margherita'),
       ('PZ456','Margherita'),
       ('PZ789','American'),
       ('PZ001','Margherita'),
       ('PZ002','Margherita'),
       ('PZ003','Margherita'),
       ('PZ004','Margherita'),
       ('PZ005','Margherita'),
       ('PZ111','Margherita'),
       ('PZ222','American'),
       ('PZ333','American'),
       ('PZ444','Margherita'),
       ('PZ555','Margherita'),
       ('PZ666','QuattroFormaggi'),
       ('PZ777','QuattroFormaggi'),
       ('PZ888','Margherita'),
       ('PZ999','Margherita');

INSERT INTO pizzaDB.restaurant1and3
VALUES (1,'PZ123',250.5,CAST('2020-12-05 16:24:46.15' AS Timestamp)),
       (1,'PZ123',255.5,CAST('2020-12-05 16:25:46.15' AS Timestamp)),
       (1,'PZ123',255.9,CAST('2020-12-05 16:26:46.15' AS Timestamp)),
       (1,'PZ123',260.0,CAST('2020-12-05 16:27:46.15' AS Timestamp)),
       (1,'PZ456',280.5,CAST('2020-12-05 16:54:55.15' AS Timestamp)),
       (1,'PZ456',290.5,CAST('2020-12-05 16:55:55.15' AS Timestamp)),
       (1,'PZ456',292.2,CAST('2020-12-05 16:56:55.15' AS Timestamp)),
       (1,'PZ456',291.0,CAST('2020-12-05 16:57:55.15' AS Timestamp)),
       (1,'PZ789',270.5,CAST('2020-12-05 17:38:47.15' AS Timestamp)),
       (1,'PZ789',280.5,CAST('2020-12-05 17:39:47.15' AS Timestamp)),
       (3,'PZ001',290.5,CAST('2020-12-05 16:24:46.15' AS Timestamp)),
       (3,'PZ001',289.5,CAST('2020-12-05 16:25:46.15' AS Timestamp)),
       (3,'PZ001',288.9,CAST('2020-12-05 16:26:46.15' AS Timestamp)),
       (3,'PZ001',292.0,CAST('2020-12-05 16:27:46.15' AS Timestamp)),
       (3,'PZ002',290.5,CAST('2020-12-05 16:28:55.15' AS Timestamp)),
       (3,'PZ002',290.5,CAST('2020-12-05 16:29:55.15' AS Timestamp)),
       (3,'PZ002',292.2,CAST('2020-12-05 16:30:55.15' AS Timestamp)),
       (3,'PZ002',291.0,CAST('2020-12-05 16:31:55.15' AS Timestamp)),
       (3,'PZ003',275.5,CAST('2020-12-05 17:45:26.15' AS Timestamp)),
       (3,'PZ003',280.5,CAST('2020-12-05 17:46:26.15' AS Timestamp)),
       (3,'PZ003',278.5,CAST('2020-12-05 17:47:26.15' AS Timestamp)),
       (3,'PZ003',290.5,CAST('2020-12-05 17:48:26.15' AS Timestamp)),
       (3,'PZ004',391.3,CAST('2020-12-05 19:45:26.15' AS Timestamp)),
       (3,'PZ004',447.2,CAST('2020-12-05 19:46:26.15' AS Timestamp)),
       (3,'PZ004',448.9,CAST('2020-12-05 19:47:26.15' AS Timestamp)),
       (3,'PZ004',453.5,CAST('2020-12-05 19:48:26.15' AS Timestamp)),
       (3,'PZ005',291.3,CAST('2020-12-05 19:25:26.15' AS Timestamp)),
       (3,'PZ005',287.2,CAST('2020-12-05 19:26:26.15' AS Timestamp)),
       (3,'PZ005',288.9,CAST('2020-12-05 19:27:26.15' AS Timestamp)),
       (3,'PZ005',295.5,CAST('2020-12-05 19:28:26.15' AS Timestamp));

INSERT INTO pizzaDB.restaurant2
VALUES ('PZ111',290.5,CAST('2020-12-05 16:24:46.15' AS Timestamp)),
       ('PZ111',289.5,CAST('2020-12-05 16:25:46.15' AS Timestamp)),
       ('PZ111',288.9,CAST('2020-12-05 16:26:46.15' AS Timestamp)),
       ('PZ111',292.0,CAST('2020-12-05 16:27:46.15' AS Timestamp)),
       ('PZ222',310.5,CAST('2020-12-05 16:28:55.15' AS Timestamp)),
       ('PZ222',310.5,CAST('2020-12-05 16:29:55.15' AS Timestamp)),
       ('PZ222',310.2,CAST('2020-12-05 16:30:55.15' AS Timestamp)),
       ('PZ222',310.0,CAST('2020-12-05 16:31:55.15' AS Timestamp)),
       ('PZ333',275.5,CAST('2020-12-05 17:45:26.15' AS Timestamp)),
       ('PZ333',280.5,CAST('2020-12-05 17:46:26.15' AS Timestamp)),
       ('PZ333',278.5,CAST('2020-12-05 17:47:26.15' AS Timestamp)),
       ('PZ333',290.5,CAST('2020-12-05 17:48:26.15' AS Timestamp)),
       ('PZ444',291.3,CAST('2020-12-05 19:45:26.15' AS Timestamp)),
       ('PZ444',287.2,CAST('2020-12-05 19:46:26.15' AS Timestamp)),
       ('PZ444',288.9,CAST('2020-12-05 19:47:26.15' AS Timestamp)),
       ('PZ444',295.5,CAST('2020-12-05 19:48:26.15' AS Timestamp)),
       ('PZ444',293.5,CAST('2020-12-05 19:49:26.15' AS Timestamp)),
       ('PZ444',294.5,CAST('2020-12-05 19:50:26.15' AS Timestamp)),
       ('PZ444',295.5,CAST('2020-12-05 19:51:26.15' AS Timestamp)),
       ('PZ444',295.5,CAST('2020-12-05 19:52:26.15' AS Timestamp)),
       ('PZ555',291.3,CAST('2020-12-05 19:25:26.15' AS Timestamp)),
       ('PZ555',287.2,CAST('2020-12-05 19:26:26.15' AS Timestamp)),
       ('PZ555',288.9,CAST('2020-12-05 19:27:26.15' AS Timestamp)),
       ('PZ555',295.5,CAST('2020-12-05 19:28:26.15' AS Timestamp)),
       ('PZ666',299.3,CAST('2020-12-05 19:35:26.15' AS Timestamp)),
       ('PZ666',300.2,CAST('2020-12-05 19:36:26.15' AS Timestamp)),
       ('PZ666',298.9,CAST('2020-12-05 19:37:26.15' AS Timestamp)),
       ('PZ666',292.5,CAST('2020-12-05 19:38:26.15' AS Timestamp)),
       ('PZ777',285.3,CAST('2020-12-05 19:45:26.15' AS Timestamp)),
       ('PZ777',287.2,CAST('2020-12-05 19:46:26.15' AS Timestamp)),
       ('PZ777',292.9,CAST('2020-12-05 19:47:26.15' AS Timestamp)),
       ('PZ777',295.5,CAST('2020-12-05 19:48:26.15' AS Timestamp)),
       ('PZ888',291.3,CAST('2020-12-05 19:45:26.15' AS Timestamp)),
       ('PZ888',287.2,CAST('2020-12-05 19:46:26.15' AS Timestamp)),
       ('PZ888',288.9,CAST('2020-12-05 19:47:26.15' AS Timestamp)),
       ('PZ888',295.5,CAST('2020-12-05 19:48:26.15' AS Timestamp)),
       ('PZ999',292.3,CAST('2020-12-05 19:40:26.15' AS Timestamp)),
       ('PZ999',289.2,CAST('2020-12-05 19:41:26.15' AS Timestamp)),
       ('PZ999',298.9,CAST('2020-12-05 19:42:26.15' AS Timestamp)),
       ('PZ999',285.5,CAST('2020-12-05 19:43:26.15' AS Timestamp));
