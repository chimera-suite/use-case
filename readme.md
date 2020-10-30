## HOW TO RUN

Comment/uncomment the file docker-compose.yml to run either the h2 or spark configuration

```console
foo@bar:~$ sudo ./docker-build.sh
foo@bar:~$ sudo docker-compose up
```

## QUERY EXAMPLE (localhost:3030  admin:admin)


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
