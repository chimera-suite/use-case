
# Chimera 🐶🐐🐍

This repository illustrates a running example of the Chimera software suite.

The example is composed of several docker images, that simulates the behaviour of data pipeline from the perspective of Data Scientists and Business Analysts, which need to use semantic web technologies (SPARQL queries and Ontology Based Data Access) for performing analytical operations and data visualization tasks. In addition, it is showed how to persist a Spark DataFrame in HDFS.

## Setup

Here we briefly discuss the components. For correctly running the example is needed to run all docker images in parallel and to respect the boot order. Please take in consideration that some docker images (Apache Hive and Apache Spark) needs several minutes to complete the startup. We suggest to use 5 terminal windows (one for each component), and run all images without the `-d` option to be able to check the output logs.

For running the dockerized components is needed to have installed `docker-compose` on your local system. If you do not have it installed, please follow this [official guide](https://docs.docker.com/compose/install/).

__REMARK__: The demo is described from a user's perspective. We assume that whoever wants to try demo runs all the docker instances on his laptop and connects to every component using his browser. Consequently, in this guide all the network addresses and ports are expressed from an outside the docker's virtual network perspective.

#### 1. Apache Hive
It simulates an `hdfs` file system.
```
docker-compose -f docker-compose-hive.yml up -d
```
You can use jdbc connection to `jdbc:hive2://localhost:10000` to check the tables and run HiveQL queries.

#### 2. Apache Spark
```
docker-compose -f docker-compose-spark.yml up -d
```
It starts an Apache Spark cluster.
In particular, the `spark-sidecar` setup component executes a series of SparkSQL statements for creating the Spark tables and performing data insertions.
Moreover it starts an Apache `Spark Thrift Server`, that exposes a JDBC enpoint for SparkSQL queries.
You can access the Apache Spark dashbaord at [http://localhost:8084](http://localhost:8084).

#### 3. OntopSpark
```
docker-compose -f docker-compose-ontop.yml up -d
```
This starts an OntopSpark instance.
The instance is configured to communicate with the Apache Spark Thrift Server.
The web interface is available at [http://localhost:8090](http://localhost:8090).

If the OntopSpark instance shuts down after a while, it may be possible that Apache Spark had encountered some problems while loading the demo tables. You can solve the issue by restarting Spark. For more detail, see the [Spark troubleshooting section](#apache-spark).

#### 4. Jena Fuseki
```
docker-compose -f docker-compose-jena-fuseki.yml up -d
```
It starts a Jena Fuseki container.
You can access the Jene Fuseki web interface at [http://localhost:3030](http://localhost:3030).

Moreover, once Jena Fuseki is ready, it is needed to log in with `admin:admin` and manually load the Knowledge Graph by creating a new _in-memory dataset_ called `pizzads` using the `MANAGE DATASETS` section, and upload the `pizza-fuseki.owl` file located in `/jena-fuseki/init`.


#### 5. Jupyter Notebook
```
docker-compose -f docker-compose-jupyter.yml up
```
This is where the Data Scientists and Business Analysts perform their analysis using the notebooks.

It is possible to access the Jupyter web interface using the links printed out from the terminal, which have the access token already integrated. For example, if you have this terminal output:

```
jupyter    |     To access the notebook, open this file in a browser:
jupyter    |         file:///home/jovyan/.local/share/jupyter/runtime/nbserver-6-open.html
jupyter    |     Or copy and paste one of these URLs:
jupyter    |         http://jupyter:8888/?token=8d16d76366b3e11448795a4521fd38ab6b17afbb3d91787a
jupyter    |      or http://127.0.0.1:8888/?token=8d16d76366b3e11448795a4521fd38ab6b17afbb3d91787a
```

You can copypaste the last link `http://127.0.0.1:8888/?token=8d16d76366b3e11448795a4521fd38ab6b17afbb3d91787a` on your browser to access the jupyter notebook web UI (`127.0.0.1` means `localhost`).


## Troubleshooting

### Apache Spark

The `spark-sidecar` setup component, which is in charge of creating the Spark tables and performing data insertions, may not correctly perform the loadings operations.

You can solve the problem by stopping the `docker-compose-spark.yml` instances and restarting them using the following commands.

```
docker-compose -f docker-compose-jena-fuseki.yml down
docker-compose -f docker-compose-jena-fuseki.yml up -d
```
Then, you can you can resume the setup from [section 3 (OntopSpark)](#3-ontop).



## Running Demo

### Scenario

PizzaInternational is a restaurant chain with many locations in both Europe and America. In order to achieve an high quality standard in all the restaurants, they decided to install new advanced ovens that integrate IoT sensors. Consequently, in order to accommodate the huge volumes of data produced by the ovens, they updated the IT infrastructure, that now resembles the one depicted in Figure.

<img src="/src/chimera_infrastructure.png" height="400px" ></img>

The ovens' observations such as temperature and cooking time are stored in the data lake that is build upon HDFS and Apache Spark.
In particular, each restaurant has its Spark table containing all the cooked pizzas with the related measures. Moreover, the restaurant tables have different schema formats. A Spark JDBC endpoint, exposed by the Apache ThriftServer, allows users to query the data lake using SparkSQL queries.

The optimal cooking parameters have been summarized by a knowledge engineer team with the help of Peppo, a Napolitan chef known to be a pizza specialist. The resulting Knowledge Graph is stored in Apache Jena Fuseki and can be queried using SPARQL. A portion of the pizza Knowledge Graph is represented in Figure.

<img src="/src/chimera_ontology.png" height="400px" ></img>

Among the cooking parameters there are temperature and cooking time for each specific category of pizza.
For example, according to Peppo's experience, a _CheeseyPizza_ must be cooked at low temperatures for avoiding to burn the cheese, while a _SpicyPizza_ can be cooked with higher temperatures, but for a shorter period of time. As a consequence, there are some pizzas that have cooking suggestions inherited from several classes of pizzas. For instance, an _American_ pizza is both a _CheeseyPizza_ and a _SpicyPizza_ and thus it has to be cooked in way that adhere to both the _CheeseyPizza_ and _SpicyPizza_ cooking suggestions.
This automatically led to the definition of precise small ranges of cooking temperatures and duration that should be satisfied to obtain a `WELL COOKED` _American_ pizza, both from a _CheeseyPizza_ and _SpicyPizza_ perspectives.

Being PizzaInternational a data driven company, the executives are interested exploiting the collected data to check the cooking performance across all the restaurants.
Given such a requirement, the central branch's Data Scientists have decided to make an explorative analysis [query Q1] of the food cooking quality across all the restaurants and save those results inside Spark tables [M1] for the Business Analysts, who needs to create a report [query Q2] for the executives showing which are the most critical restaurants.

<img src="/src/chimera_tutorial.png" height="400px" ></img>

### Solution

Before starting it is needed to load the Knowledge Graph in Jena Fuseki. Go to [http://localhost:3030](http://localhost:3030), and click on the `MANAGE DATASET` section on the top bar, and create a ne new _in-memory dataset_ called `pizzads`. Then, you can __upload__ the ontology file located in `/jena-fuseki/init/pizza-fuseki.owl`.

For runnig the notebook's analytical tasks it is needed to go on the Jupyter web interface. Go to [http://localhost:8888](http://localhost:8888) and click on the __upload__ button on the top right to add two notebooks : `notebook_DS.ipyml` and `notebook_BA.ipyml`. All the subsequent steps of this tutorial are performed inside the two notebooks

Let's start by opening the `notebook_DS.ipyml`. This is the notebook created by the Data Scientist team, which needs to make an anomaly detection anlysis to decide if a pizza cooked by a restaurant is _good_ or _anomalous_. In order to perform their analysis, the decided to use PySPARQL to execute a __SPARQL query__. This ensures flexibility because they can use any python data science library while benefitting from Peppo's experience captured in the KG. The query code is the following.

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

We can notice that there is a part of the query inside the `SERVICE <http://ontop:8080/sparql>`clause, which is called _federated query_. This part of the query is solved by OntopSpark using the VKG approach, which retrieves the SQL tuples stored in the Spark tables by making SparkSQL queries and translating the results into instances using the SQL-to-RDF mappings. In addition, the KG stored in Jena Fuseki enriches the Ontop Spark result, by adding the semantic information. The remaining part of the query uses the KG to express the decision rules in the `BIND` clause to determine the pizza quality outcome.
Furthermore, in the example the `:American` pizzas instances are both `:CheeseyPizza` and `:SpicyPizza`, so they have to be cooked according to the optimal parameters asserted for both the classes. This led to some `:American` pizzas be considered _"WELL COOKED"_ for the `:CheeseyPizza` class but not for the `:SpicyPizza` class and vice versa.

The query is executed inside the notebook using the PySPARQL library, which enables the user to execute a __SPARQL queries__ and get the results automatically translated in __Spark DataFrames__ using the following code.

```
wrapper = PySPARQLWrapper(spark, sparql_endpoint)
result = wrapper.query(query)
resultDF = result.dataFrame
```

Once the analyzes are complete, the Data Scientists can use the following code to __persist__ the resuts into a __Spark table__ for making them available to Business Analysts.

```
df2.write.mode("overwrite").saveAsTable('pizzadb.analysis')
```

The first iteration of the analysis is completed. We can now open the second notebook called `notebook_BA.ipyml`. The Business Analysts are interested in creating an histogram showing the most critical restaurants. In this case they need both the Data Scientists results from the first round-trip iteration and the original restaurants data to retrieve in which restaurant a specific pizza has been cooked. Both the information are persisted in Spark tables. In addition, they also need an ontology describing the concept of good or bad quality for the pizzas, which is stored in the Fuseki's Knowledge Graph. The following query notebook's __SPARQL query__ perform a counting operation of the anomalous pizzas over all the quality cheched, in order to display the percentages of anomalous pizzas for each restaurant.

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

Fuseki and OntopSpark manage the query procedure as in the previous example. However, this time the BAs does not store the results in a Spark table but use a __Pandas barplot__ to prepare the visualization for the executives using the following code.



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

To be noticed that the built plot is dynamic, as it depends on the number of restaurants in the Spark tables.
