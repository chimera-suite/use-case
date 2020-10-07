#!/bin/sh
dir=$(dirname "$0")

java -jar $dir/apache-jena-fuseki-3.16.0/fuseki-server.jar &

$dir/h2/bin/h2.sh &

$dir/Protege-5.5.0/run.sh


