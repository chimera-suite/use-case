
## HOW TO RUN

Comment/uncomment the file docker-compose.yml to run either the h2 or spark configuration

```console
foo@bar:~$ sudo ./spark-build.sh
foo@bar:~$ sudo docker-compose -f docker-compose-spark-jena-fuseki.yml up
foo@bar:~$ sudo docker-compose -f docker-compose-ontop.yml up
```

## QUERY EXAMPLE (localhost:3030  admin:admin)

    PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

    SELECT *
    WHERE {

      ?x :suggestedCookingTemp ?suggestedTemp .

      SERVICE <http://ontop:8080/sparql> {
        ?pizzaID a ?x; :temperature ?avgTemp.
      }

      OPTIONAL { FILTER( ?avgTemp < ?suggestedTemp*0.90 || ?avgTemp > ?suggestedTemp*1.25 )
          BIND("BRUCIATA" AS ?v)
      }
      OPTIONAL { FILTER( ?avgTemp >= ?suggestedTemp*0.90 && ?avgTemp <= ?suggestedTemp*1.25 )
          BIND("BEN COTTA" AS ?v)
      }

    }

Old query....to be checked


    PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

    SELECT ?pizzaType ?sensor ?value ?time
    WHERE {
        ?pizzaType rdfs:subClassOf  [ owl:onProperty      :hasTopping ;
                                      owl:someValuesFrom  :MozzarellaTopping ] ;
                   rdfs:subClassOf  [ owl:onProperty      :hasTopping ;
                                      owl:someValuesFrom  :OliveTopping ] ;
                   rdfs:label ?l .
        SERVICE <http://ontop:8080/sparql> {
            ?pizzaID :hasSensorMeasure [:value ?value; :capturedAt ?time; :detectedBy ?sensor];
                      rdfs:label ?l .
        }
        BIND ((now() - "P45DT4H"^^xsd:dayTimeDuration) AS ?duration)
        FILTER( ?time <= now() && ?time > ?duration )
    }
