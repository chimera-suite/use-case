[QueryItem="pizza-type"]
PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

SELECT ?x ?y
WHERE 	{ ?x	a	:Pizza;
		rdfs:label	?y.
	}

[QueryItem="pizza-oven"]
PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

SELECT DISTINCT ?x ?y ?temp ?time
WHERE 	{ 
	    ?x :hasSensorMeasure ?y.
	    ?y :value ?temp; :capturedAt ?time.
	}

[QueryItem="pizza-margherita"]
PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

SELECT DISTINCT ?x ?y ?temp ?time
WHERE 	{ 
	    ?x a :Margherita; a :Pizza; a :NamedPizza.
	    ?x :hasSensorMeasure ?y.
	    ?y :value ?temp; :capturedAt ?time.
	}

[QueryItem="pizza-oven2"]
PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

SELECT DISTINCT ?pizza ?temp ?time
WHERE 	{ 
	    ?pizza :hasSensorMeasure [:value ?temp; :capturedAt ?time].
	}

[QueryItem="pizza-fourSeasons"]
PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

SELECT DISTINCT ?x ?y ?temp ?time
WHERE 	{ 
	    ?x a :FourSeasons; a :Pizza; :hasTopping :OliveTopping.
	    ?x :hasSensorMeasure ?y.
	    ?y :value ?temp; :capturedAt ?time.
	}

[QueryItem="TODO-fix"]
PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

SELECT DISTINCT ?x ?y ?temp ?time
WHERE 	{ 
	    ?x a :Pizza.
	    ?x :hasSensorMeasure ?y.
	    ?y :value ?temp; :capturedAt ?time.
	}
