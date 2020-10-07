FROM ontop/ontop-endpoint
WORKDIR /opt/ontop
COPY input/pizza-full.owl input/pizza-full.obda input/pizza-full.docker.properties input/ 
COPY jdbc/h2-1.4.196.jar jdbc/
EXPOSE 8080
ENTRYPOINT java -cp ./lib/*:./jdbc/* -Dlogback.configurationFile=file:./log/logback.xml \
        it.unibz.inf.ontop.cli.Ontop endpoint \
        --ontology=input/pizza-full.owl \
        --mapping=input/pizza-full.obda \
        --properties=input/pizza-full.docker.properties \
        --cors-allowed-origins=http://yasgui.org \
        --lazy # if needed

