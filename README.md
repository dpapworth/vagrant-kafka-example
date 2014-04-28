vagrant-kafka-example
=====================

Example Vagrant set up for Kafka and Zookeeper.

Virtual Nodes:
--------------

    zk01.lan    192.168.10.10
    zk02.lan    192.168.10.11
    zk03.lan    192.168.10.12
    kafka01.lan 192.168.10.13
    kafka02.lan 192.168.10.14

Usage:
------
Create a Kafka topic

    % sh kafka-topics.sh --create --topic test1 --partitions 2 --replication-factor 2 --zookeeper zk01.lan:2181,zk02.lan:2181,zk03.lan:2181
  
Create a consumer for the topic

    % sh kafka-console-consumer.sh --topic test1 --zookeeper zk01.lan:2181,zk02.lan:2181,zk03.lan:2181

Create a producer for the topic

    % sh kafka-console-producer.sh --topic test1 --broker-list kafka01.lan:9092,kafka02.lan:9092
