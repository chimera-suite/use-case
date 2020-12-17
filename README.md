# Chimera 🐶🐐🐍

This repository illustrates a running example of the Chimera software suite.

The example is composed of several docker images, that simulates the behaviour of data pipeline from the relational data to the jupyter notebooks, passing through semantic web technologies.

## Setup

Here we briefly discuss the components. For correctly running the example is needed to run all docker images in parallel and respecting the boot order.


#### 1. Apache Hive
It simulates an `hdfs` file system.
```
docker-compose -f docker-compose-hive.yml up -d
```
You can use jdbc connection to `jdbc:hive2://hive-server:10000` to check the tables and run HiveQL queries.
An Hive metastore is available at `thrift:hive-metastore:9083`.

#### 2. Apache Spark
```
docker-compose -f docker-compose-spark.yml up -d
```
It starts an Apache Spark cluster.
and a [spark-sidecar-setup component] that, expoiting SparkSQL, executes a series of SQL statements against Hive.
Moreover is starts an Apache Spark Thriftserver, that exposes a jdbc enpoint for SparkSQL queries.
You can access the Apache Spark dashbaord at [http://spark-master:8080](http://localhost:8084).

#### 3. Ontop
```
docker-compose -f docker-compose-ontop.yml up -d
```
This starts an Ontop instance.
In particular the instance is configured to communicate with the Apache Spark Thriftserver.
The web interface is available at [http://ontop:8080](http://localhost:8090).

#### 4. Jena Fuseki
```
docker-compose -f docker-compose-jena-fuseki.yml up -d
```
It start a Jena Fuseki container.
Moreover, once Jena Fuseki is ready, it creates a dataset and upload the Knowledge Graph.
You can access the Jene Fuseki web interface at [http://jena-fuseki:3030](http://localhost:3030).

You can test the correct startup of all the previous modules by prompting the following query.

```
PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

SELECT (COUNT(?foodID) as ?count)
WHERE {
    SERVICE <http://ontop:8080/sparql> {
      ?foodID a :Food.
    }
}
```

#### 5. Jupyter Notebook
```
docker-compose -f docker-compose-jupyter.yml up -d
```
This is where all the magic happens.
You can access the Jupyter web interface at [http://jupyter:8888](http://localhost:8888).

Enjoy 😁

## Running Demo

For runnig the example is needed to go on the Jupyter web interface at [http://jupyter:8888](http://localhost:8888).

Then, click on the __upload__ button top right and add the two notebooks : `notebook_DS.ipyml` and `notebook_BA.ipyml`

Let's start with `notebook_DS.ipyml`. This is the notebook that has been created by the data scientist team, which have the need of making an anomaly detection anlysis to decide if a food cooked by a restaurant is _good_ or _anomalous_. In order to perform their analysis, the have created the following __SPARQL query__.

```
sparql_endpoint = "http://jena-fuseki:3030/pizzads"

query = """
    PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

    SELECT ?foodID ?outcome
    WHERE {

      ?foodType :suggestedCookingTemp ?suggestedTemp; :suggestedCookingDuration ?suggestedDuration .

      SERVICE <http://ontop:8080/sparql> {
        ?foodID a ?foodType.
        ?foodID :temperature ?avgTemp; :start_cooking ?start; :end_cooking ?end.
      }

      BIND ((?end-?start) AS ?cookingDuration)

      BIND(IF ((?avgTemp >= ?suggestedTemp*0.90 && ?avgTemp <= ?suggestedTemp*1.25) &&
               (?cookingDuration >= ?suggestedDuration*0.80 && ?cookingDuration <= ?suggestedDuration*1.40)
               ,"WELL_COOKED","ANOMALY") AS ?outcome)
    }
"""

```

We can notice that there is a part of the query inside the `SERVICE <http://ontop:8080/sparql>`clause, which is called federated query. This part of the query resolved by Ontop Spark using theVKG approach, which retrieves the SQL tuples stored in the Hive tables by making SparkSQL queriesand translating the resul using the SQL-to-RDF mappings. In addition, the ontology stored in Fusekienriches the OntopSpark RDF result, by adding the semantical information stored in the KnowledgeGraph about the suggested temperature and cooking time for a given type of food.

The query can be in the executed in the notebook with the PySPARQL library, which is able to retrieve the RDF result and to translate it in a __Spark dataframe__ with the following code.

```
wrapper = SPARQL2SparkWrapper(spark, sparql_endpoint)
result = wrapper.query(query)
resultDF = result.dataFrame
```

After some manipulation of the dataframe, it's possible to __store__ again in a __Hive table__. In our case we use an overvrite operation, because the empty table has been already created during the Spark docker startup.

```
df2.write.mode("overwrite").saveAsTable('pizzadb.analysis')
```

The first iteration of the anlysis is completed. We can now open the secon notebook `notebook_BA.ipyml`, which has been created by a business analyst that needs to build a graphical report about the food quality of each restaurant. For example, he could be interested in knowing which are the percentages of anomalous pizzas for each restaurant by running the following __SPARQL query__ in the notebook.

```
sparql_endpoint = "http://jena-fuseki:3030/pizzads"

query = """
    PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

    SELECT (COUNT(?anomalous)/(COUNT(?good)+COUNT(?anomalous)) as ?count) ?restaurant
    WHERE {
      SERVICE <http://ontop:8080/sparql> {
        {?anomalous a :AnomalousFood; a :Pizza; :restaurant ?restaurant.}
        UNION
        {?good a :GoodFood; a :Pizza; :restaurant ?restaurant.}
      }
    }
    GROUP BY ?restaurant
"""
```

By specifyng that the food must be a `:Pizza`, it's possible to retieve from the Hive tables only the food that is mappes on this category. However, the analysis can be repeated to anothe category of food by changing the class, for example in `:Dessert`.

The query execution is the same as before by using SPARQL2SparkWrapper for building the Spark dataframe.

In this case the business analyst doesn't need to store again the data in Hive tables (his role is limited to consuming the results produced by the data scientists), but is interested in building some plots using a python library for data visualization. For example, he could build a __Pandas barplot__ showing the percentages of anomalies with the following code.


```
import pandas as pd

# From Spark dataframe to Pandas dataframe
pandasDF = resultDF.toPandas()

# Build the plot
df = pd.DataFrame({'RESTAURANTS':pandasDF["restaurant"],'%ANOMALIES':pandasDF["count"].astype(float)})
ax = df.plot.barh(x='RESTAURANTS', y='% ANOMALIES', stacked=True,figsize=(5,1))
ax.set_xlim(0,1)
```

The builded plot is dynamic, because it depends on a number of restaurants that depends on a Pandas column that can achieve remarkable sizes.
