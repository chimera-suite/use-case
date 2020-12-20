
# Chimera 🐶🐐🐍

This repository illustrates a running example of the Chimera software suite.

The example is composed of several docker images, that simulates the behaviour of data pipeline from the perspective of Data Scientists and business Analysts, which have the need of using semantic web technologies (SPARQL queries and Ontology Based Data Access) for performing analytical operations and data visualization tasks. In addition it is showed how to persist a Spark DataFrame in HDFS.
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

Moreover, once Jena Fuseki is ready, it is needed to log in with `admin:admin` and  manually load the Knowledge Graph by creating a new _in-memory dataset_ in the `MANAGE DATASETS` section, and uploding the `pizza-fuseki.owl` file located in `/jena-fuseki/init`.


#### 5. Jupyter Notebook
```
docker-compose -f docker-compose-jupyter.yml up -d
```
This is where all the magic happens.
You can access the Jupyter web interface at [http://jupyter:8888](http://localhost:8888).

Enjoy 😁

## Running Demo

### Scenario

PizzaInternational is a restaurant chain with many locations in both Europe and America.
In order to achieve an high quality standard in all the restaurants, they decided to install new advanced ovens that integrate IoT sensors.
Consequently, in order to accommodate the huge volumes of data produced by the ovens, they updated the IT infrastructure, that now resembles the one depicted in Figure.

<img src="/src/chimera_infrastructure.png" height="400px" ></img>

The ovens' observations such as temperature and cooking time are stored in the data lake that is build upon HDFS and Apache Spark.
In particular, each restaurant has its Spark table containing all the cooked pizzas with the related measures.
Moreover, the restaurant tables have different schema formats.
A Spark JDBC endpoint, exposed by the Apache ThriftServer, allows users to query the data lake using SparkSQL queries.

The optimal cooking parameters have been summarized by a knowledge engineer team with the help of Peppo, a Napolitan chef known to be a pizza specialist.
The resulting Knowledge Graph is stored in Apache Jena Fuseki and can be queried using SPARQL.
A portion of the pizza Knowledge Graph is represented in Figure.

<img src="/src/chimera_ontology.png" height="400px" ></img>

Among the cooking parameters there are temperature and cooking time for each specific category of pizza.
For example, according to Peppo's experience, a _CheeseyPizza_ must be cooked at low temperatures for avoiding to burn the cheese, while a _SpicyPizza_ can be cooked with higher temperatures, but for a shorter period of time.
As a consequence, there are some pizzas that have cooking suggestions inherited from several classes of pizzas.
For instance, an _American_ pizza is both a _CheeseyPizza_ and a _SpicyPizza_ and thus it has to be cooked in way that adhere to both the _CheeseyPizza_ and _SpicyPizza_ cooking suggestions.
This automatically led to the definition of precise small ranges of cooking temperatures and duration that should be satisfied to obtain a `WELL COOKED` _American_ pizza, both from a _CheeseyPizza_ and _SpicyPizza_ perspectives.

Being PizzaInternational a data driven company, the executives are interested exploiting the collected data to check the cooking performance across all the restaurants.
Given such a requirement, the central branch's Data Scientists have decided to make an explorative analysis [query Q1] of the food cooking quality across all the restaurants and save those results inside Spark tables [M1] for the Business Analysts, who needs to create a report [query Q2] for the executives showing which are the most critical restaurants.

<img src="/src/chimera_tutorial.png" height="400px" ></img>

### Solution

Before strating it's needed to load the Knowledge Graph in Jena Fuseki. Go to [http://jena-fuseki:3030](http://localhost:3030), and click on the `MANAGE DATASET` section on the top bar, it is possible to create a ne new _in-memory dataset_, which has to be called `pizzads`. Then, you can __upload__ the ontology file located in `/jena-fuseki/init/pizza-fuseki.owl`.

Then, for runnig the example is needed to go on the Jupyter web interface. Go to [http://jupyter:8888](http://localhost:8888) and click on the __upload__ button on the top right to add two notebooks : `notebook_DS.ipyml` and `notebook_BA.ipyml`

Let's start with `notebook_DS.ipyml`. This is the notebook that has been created by the Data Scientist team, which have the need of making an anomaly detection anlysis to decide if a pizza cooked by a restaurant is _good_ or _anomalous_. In order to perform their analysis, the have created the following __SPARQL query__.

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

We can notice that there is a part of the query inside the `SERVICE <http://ontop:8080/sparql>`clause, which is called federated query. This part of the query is solved by OntopSpark using the VKG approach, which retrieves the SQL tuples stored in the Spark tables by making SparkSQL queries and translating the results into instances using the SQL-to-RDF mappings. In addition, the KG stored in Jena Fuseki enriches the Ontop Spark result, by adding the semantic information.

The query can be in the executed in the notebook with the PySPARQL library, which is able to retrieve the query result and to translate it in a __Spark DataFrame__ using the following code.

```
wrapper = PySPARQLWrapper(spark, sparql_endpoint)
result = wrapper.query(query)
resultDF = result.dataFrame
```

After the Data Scientists have manipulated the Spark DataFrame for performing thei anlyses, they can to __persist__ it in a __Spark table__. In the example is used an overvrite operation, because the an empty table has been already created during the Spark startup.

```
df2.write.mode("overwrite").saveAsTable('pizzadb.analysis')
```

The first iteration of the anlysis is completed. We can now open the second notebook called `notebook_BA.ipyml`. The Business Analysts are interested in creating an histogram that shows the most critical restaurants. In this case they need both the Data Scientists results from the first round-trip iteration, and the original restaurants data, which can be used to retrieve in which restaurant a specific pizza has been cooked. Both the information are persisted in Spark tables. In addition, they also need an ontology describing the concept of good or bad quality for the pizzas, which is stored in the Fuseki's Knowledge Graph. The following query notebook's __SPARQL query__ perform a counting operation of the anomalous pizzas over all the quality cheched, in order to display the percentages of anomalous pizzas for each restaurant.

```
sparql_endpoint = "http://jena-fuseki:3030/pizzads"

query = """
    PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

    SELECT (COUNT(?anomalous)/(COUNT(?pizzaChecked)) as ?count) ?restaurant
    WHERE {
        SERVICE <http://ontop:8080/sparql> {
            {?anomalous a :AnomalousPizza; :restaurant ?restaurant.}
            UNION
            {?pizzaChecked a :QAPizza; :restaurant ?restaurant.}
        }
    }
    GROUP BY ?restaurant
"""
```

The Business analysts can plot a simple barplot using a data visualization library. For example, they can build a __Pandas barplot__ using the following code.


```
import pandas as pd

# From Spark dataframe to Pandas dataframe
pandasDF = resultDF.toPandas()

# Build the plot
df = pd.DataFrame({'RESTAURANTS':pandasDF["restaurant"], '% ANOMALIES':pandasDF["count"].astype(float)})
ax = df.plot.barh(x='RESTAURANTS', y='% ANOMALIES', stacked=False,figsize=(7,2))
ax.set_ylabel("")
ax.set_xlim(0,1)
```

To be noticed that the builded plot is dynamic, because it depends on the number of restaurants in the HDFS repository.
