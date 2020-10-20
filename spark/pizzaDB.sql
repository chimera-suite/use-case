DROP DATABASE IF EXISTS pizzaDB CASCADE;

CREATE DATABASE IF NOT EXISTS pizzaDB;
                          
CREATE TABLE pizzaDB.pizza (
          pizzaID VARCHAR(10) NOT NULL,
          menuName VARCHAR(30) NOT NULL);
          
CREATE TABLE pizzaDB.sensor (
          sensorID VARCHAR(10) NOT NULL,
          measureType VARCHAR(30) NOT NULL);
          
CREATE TABLE pizzaDB.measures (
          measureID VARCHAR(10) NOT NULL,
          pizzaID VARCHAR(10) NOT NULL,
          sensorID VARCHAR(10) NOT NULL,
          value DECIMAL(4,1) NOT NULL,
          timestamp TIMESTAMP NOT NULL);
          
INSERT INTO pizzaDB.measures
VALUES ('TEMP0001','PZ123','S1',250.5,CAST ('2020-10-01 23:54:46.15' AS Timestamp)),('TEMP0002','PZ222','S1',273.0,CAST ('2020-10-05 13:54:46.15' AS Timestamp)),('HUM0001','PZ222','S2',0.30,CAST ('2020-10-05 13:55:46.15' AS Timestamp)),('TEMP0003','PZ333','S1',380.0,CAST ('2020-10-02 23:54:46.15' AS Timestamp)),('TEMP0004','PZ444','S1',254.7,CAST ('2020-10-05 16:24:46.15' AS Timestamp)),('HUM0002','PZ444','S2',0.35,CAST ('2020-10-05 16:25:46.15' AS Timestamp)),('TEMP0005','PZ444','S3',258.9,CAST ('2020-10-05 16:26:46.15' AS Timestamp)),('TEMP0006','PZ456','S1',270.2,CAST ('2020-10-03 23:54:46.15' AS Timestamp)),('TEMP0007','PZ789','S1',260.9,CAST ('2020-10-04 23:54:46.15' AS Timestamp));

INSERT INTO pizzaDB.pizza
VALUES ('PZ123','Veneziana'),('PZ222','Margherita'),('PZ333','FourSeasons'),('PZ444','Margherita'),('PZ456','Margherita'),('PZ789','FourSeasons');

INSERT INTO pizzaDB.sensor
VALUES ('S1','TEMPERATURE'),('S2','HUMIDITY'),('S3','TEMPERATURE');