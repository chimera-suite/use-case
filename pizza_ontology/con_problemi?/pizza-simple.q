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
		:hasMeasure [ :value ?y ; :capturedAt ?t ].
	}

[QueryItem="pizza-oven2"]
PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

SELECT ?x ?y
WHERE 	{ ?x	a	:Pizza;
		:hasMeasure ?y;
	}

[QueryItem="pizza-oven3"]
PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

SELECT ?x ?y ?temp ?time
WHERE 	{ ?x	a	:Pizza;
		:hasMeasure ?y .
	    ?y :value ?temp ; :capturedAt ?time .
	}

[QueryItem="pizza-margherita"]
PREFIX : <http://www.co-ode.org/ontologies/pizza/pizza.owl#>

SELECT ?x
WHERE 	{ ?x	a	:Margherita; }
