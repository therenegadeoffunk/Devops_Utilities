**Kafka Notes**

_Lingo: [Producer, Consumer, Stream, Connector, Topic, Record, Broker]_

_Basics_

Four APIs: Producer, Consumer, Streams, Connector
Communication protocol is TCP. Java is main library (but there are clients for other langs!)
Topics: Records are published to topics, can have multiple consumers. Retention time is configurable.
Topics: For each topic there is a partitioned log. Each partition is an immutable set of records
Partitions: Each record in a partition has a sequential ID called an offset and a timestamp.
Consumers: Cheap, can come and go, can read in any order they want, partitions must fit on server
Partitions: Replication is configurable (fault tolerance)
Distribution: Leaders and followers. Followers replicate. If leader dies, follower becomes leader.
Consumers: Each partition publishes to a single consumer instance within a consumer group
Kafka distributes partitions among consumer instances FAIRLY
If TOTAL ORDER needed, then enforce ONE partition (you only get one process per group tho)
Kafka gives you strengths of queueing and publish subscribe (scale up consumption+processing)
Kafka gives you parallelized consumption with ordering guarantees (one-partition-one-consumer)
Kafka is also a decent storage system. Configurable. Can enforce replication guarantees.


_Newer Stuff_

Kafka Connect Source (producers) and Kafka Connect Sink (consumers), Mirror Maker
Confluent: Avro Data + Kafka Schema Registry (Java producers and consumers) REST Proxy
Admin Stuff: Topics UI, Schema UI, Connect UI, Kafka Manager, Burrow, Exhibitor, JMX Dump


_Administration_

Easy to run with Docker, Requires Zookeeper, Lock down ports! Use the Kafka UI if possible
Rarely delete topics (just publish to a new one), can do command line producer / consumer for tests
**Consumer-offsets topic and other system topics**
Default Ports: Kafka=9092, 3030 (UI), 8081-8083  ZooKeeper=2181
Configuration: Many knobs to turn – [https://kafka.apache.org/documentation/#configuration](https://kafka.apache.org/documentation/#configuration)


_Topic Configuration_

Affects performance! Know defaults! Replication, Partitition #, Message Size, Logs, Compression
Change using command line tool. Most critical: Partitions count and replication factor
Partition Count: Change is painful. Can't delete. Break key order guarantees. Over-provision is best
~10 MB per partition per sec. What happens with many partitions?:
More throughput more parallelism, more open files, painful rebalances, more replication latency
Guide: Keep partitions per broker between 2000 and 4000, total cluster should be under 20,000
Partitions per topic: (1 or 2 \* number of brokers, no more than 10)
Replication Factor: Too much adds stress to system. Just stick with 3
Segments: Files that are bits of partitions, have indexes offset to position and timestamp to offset
Note: Timestamp index is new (Kafka .10 or newer)
log.segment.bytes: segment size + frequency log compaction, default 1GB, small-&gt;many open files
log.segment.ms: defaults to weekly compaction (maybe you want daily? Test throughput)
log.cleanup.policy: Delete logs after time (week default) or Compact them (default for offsets topic)


_Logs_

Log Cleanup: Critical. How long data is retained. Small segments=more cleanups (more files tho…)
Log Cleanup: Takes up CPU and RAM! Frequency is changeable log.cleaner.backoff.ms
Delete Policy: log.retention.hours, higher number is more disk space. Can keep files indefinitely
Delete Policy: log.retention.bytes, delete based on partition size, default is -1 (infinite size)
Log Compaction: Ensure that last known value for specific key within a partition is retained
Good for snapshotting (employee salary example), retained by config: delete.retention.ms
Doesn't prevent reading duplication, also it can fail (memory),
Log Compression: compression.type → gzip, snappy, lz4, producer, uncompressed
Log Compression: defaults to 'producer', saves work for brokter, send batches if enabled!
Log Compression: Consumer will uncompress. Only makes sense for non-binary (text, json)


_More Tuning_

max.messages.bytes (for sending larger messages. Increase buffer on consumer!)
unclean.leader.election (default to true. Don't mess with. Can cause data loss. Out of sync leaders)

_TODO_

_Kafka Administration for DevOps_

_Even More Tuning!_

_Kafka Connect I_

_Kafka Connect II_

_Kafka Streaming I_

_Kafka Streaming II_



_Consumers and Producers_

Many Kafka libraries, Java is probably best. [https://github.com/apache/kafka](https://github.com/apache/kafka) best example code

Prefer asynchronous producers (synchronous blocks and slows), use CallBacks and Metadata

_Useful Commands_

**Create Topic:** kafka-topics --zookeeper $ZK\_HOST:2181 --create --topic first\_topic --partitions 3 --replication-factor 1

**Change Topic Config:** kafka-topics –alter –topic $topic\_name –config cleanup.policy=delete –zookeeper $ZK\_HOST:2181

**List Topics:** kafka-topics –zookeeper $ZK\_HOST:2181 –list

**Delete Topic:** kafka-topics –zookeeper $ZK\_HOST:2181 –topic $TOPIC –delete

**Produce Data to Topic:** kafka-console-producer –broker-list $broker:9092 –topic first\_topic

**Consume Data from Topic:** kafka-console-consumer –broker-list $broker:9092 –topic $TOPIC

_Sources!_

[https://www.confluent.io/blog/how-to-choose-the-number-of-topicspartitions-in-a-kafka-cluster/](https://www.confluent.io/blog/how-to-choose-the-number-of-topicspartitions-in-a-kafka-cluster/)

[https://blog.imaginea.com/how-to-rebalance-topics-in-kafka-cluster/](https://blog.imaginea.com/how-to-rebalance-topics-in-kafka-cluster/)

[https://cwiki.apache.org/confluence/display/KAFKA/Performance+testing](https://cwiki.apache.org/confluence/display/KAFKA/Performance+testing)

[https://logallthethings.com/2016/07/11/min-insync-replicas-what-does-it-actually-do/](https://logallthethings.com/2016/07/11/min-insync-replicas-what-does-it-actually-do/)

KAFKA COMMANDS:

kafka-acls

kafka-replay-log-producer

kafka-avro-console-consumer

kafka-replica-verification

kafka-avro-console-producer

kafka-rest-run-class

kafka-broker-api-versions

kafka-rest-start

kafka-configs

kafka-rest-stop

kafka-console-consumer

kafka-rest-stop-service

kafka-console-producer

kafka-run-class

kafka-consumer-groups

kafka-server-start

kafka-consumer-offset-checker

kafka-server-stop

kafka-consumer-perf-test

 kafka-simple-consumer-shell

kafka-delete-records

kafka-streams-application-reset

kafka-mirror-maker

kafka-topics

kafka-preferred-replica-election

kafka-verifiable-consumer

kafka-producer-perf-test

kafka-verifiable-producer

kafka-reassign-partitions

_Y ZOOKEEPER THO?_

Kafka uses Zookeeper for the following:

1. Electing a controller. The controller is one of the brokers and is responsible for maintaining the leader/follower relationship for all the partitions. When a node shuts down, it is the controller that tells other replicas to become partition leaders to replace the partition leaders on the node that is going away. Zookeeper is used to elect a controller, make sure there is only one and elect a new one it if it crashes.

2. Cluster membership - which brokers are alive and part of the cluster? this is also managed through ZooKeeper.

3. Topic configuration - which topics exist, how many partitions each has, where are the replicas, who is the preferred leader, what configuration overrides are set for each topic

4. (0.9.0) - Quotas - how much data is each client allowed to read and write

5. (0.9.0) - ACLs - who is allowed to read and write to which topic

6. (old high level consumer) - Which consumer groups exist, who are their members and what is the latest offset each group got from each partition.

I think that covers it :)

The last use-case is the only one that is going away.
