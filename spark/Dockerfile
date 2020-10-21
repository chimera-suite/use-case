FROM debian

RUN apt update
RUN apt install wget default-jdk scala git python3 -y

WORKDIR /tmp

RUN wget https://downloads.apache.org/spark/spark-3.0.1/spark-3.0.1-bin-hadoop2.7.tgz
RUN tar xvf spark-*
RUN mv spark-3.0.1-bin-hadoop2.7 /opt/spark

RUN apt install procps -y

ENV SPARK_HOME=/opt/spark
ENV PATH=${PATH}:${SPARK_HOME}/bin:${SPARK_HOME}/sbin
ENV PYSPARK_PYTHON=/usr/bin/python3

WORKDIR /home

COPY start.sh start.sh
COPY pizzaDB.sql pizzaDB.sql

RUN chmod +x start.sh

EXPOSE 8050
EXPOSE 8051
EXPOSE 10000

CMD [ "./start.sh" ]
