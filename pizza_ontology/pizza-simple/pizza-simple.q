[QueryItem="pizza-type"]
PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

SELECT ?x ?y
WHERE 	{ ?x	a	:Pizza;
		rdfs:label	?y.
	}

[QueryItem="pizza-oven"]
PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

SELECT ?x ?y ?t
WHERE 	{ ?x	a	:Pizza;
		:value ?y ; :capturedAt ?t .
	}

[QueryItem="pizza-margherita"]
PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

SELECT ?x ?y ?z
WHERE 	{ ?x a :Pizza ; :hasMeasure :x . 
	   :x :value ?y; :capturedAt ?z. }
