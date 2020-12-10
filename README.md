

## HOW TO RUN

Comment/uncomment the file docker-compose.yml to run either the h2 or spark configuration

```console
foo@bar:~$ sudo ./spark-build.sh
foo@bar:~$ sudo docker-compose -f docker-compose-spark-jena-fuseki.yml up
foo@bar:~$ sudo docker-compose -f docker-compose-ontop.yml up
```

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
