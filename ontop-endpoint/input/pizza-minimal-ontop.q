[QueryItem="test"]
PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT *
WHERE {
     ?x a :Pizza; :temperature ?y;:start_cooking ?start; :end_cooking ?end; :restaurant ?z.
}
