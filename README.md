# Chimera 🐶🐐🐍

This repository illustrates a running example of the Chimera software suite.
Here we briefly discuss the components.

#### Apache Hive
It simulates an `hdfs` file system.
```
docker-compose -f docker-compose-hive.yml up -d
```
You can use jdbc connection to `jdbc:hive2://hive-server:10000` to check the tables and run HiveQL queries.
An Hive metastore is available at `thrift:hive-metastore:9083`.

#### Apache Spark
```
docker-compose -f docker-compose-spark.yml up -d
```
It starts an Apache Spark cluster.
and a [spark-sidecar-setup component] that, expoiting SparkSQL, executes a series of SQL statements against Hive.
Moreover is starts an Apache Spark Thriftserver, that exposes a jdbc enpoint for SparkSQL queries.
You can access the Apache Spark dashbaord at [http://spark-master:8080](http://localhost:8084).

#### Ontop
```
docker-compose -f docker-compose-ontop.yml up -d
```
This starts an Ontop instance.
In particular the instance is configured to communicate with the Apache Spark Thriftserver.
The web interface is available at [http://ontop:8080](http://localhost:8090).

#### Jena Fuseki
```
docker-compose -f docker-compose-jena-fuseki.yml up -d
```
It start a Jena Fuseki container.
Moreover, once Jena Fuseki is ready, it creates a dataset and upload the Knowledge Graph.
You can access the Jene Fuseki web interface at [http://jena-fuseki:3030](http://localhost:3030).

#### Jupyter Notebook
```
docker-compose -f docker-compose-jupyter.yml up -d
```
This is where all the magic happens.
You can access the Jupyter web interface at [http://jupyter:8888](http://localhost:8888).

Enjoy 😁

## QUERY EXAMPLE (localhost:3030  admin:admin)

    PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

    SELECT ?pizzaID ?outcome
    WHERE {

      ?pizzaType :suggestedCookingTemp ?suggestedTemp; :suggestedCookingDuration ?suggestedDuration .

      SERVICE <http://ontop:8080/sparql> {
        ?pizzaID a ?pizzaType.
        ?pizzaID :temperature ?avgTemp; :start_cooking ?start; :end_cooking ?end.
      }

      BIND ((?end-?start) AS ?cookingDuration)

      BIND(IF ((?avgTemp >= ?suggestedTemp*0.90 && ?avgTemp <= ?suggestedTemp*1.25) &&
          	   (?cookingDuration >= ?suggestedDuration*0.80 && ?cookingDuration <= ?suggestedDuration*1.40)
               ,"WELL_COOKED","ANOMALY") AS ?outcome)
    }
