**Apache Spark Reference**

_Basics_

What is Spark: Distributed computing framework built in Scala
Scala: Drivers for other languages, but Scala is best. Learn Scala. Spark Shell!
RDD: Resilient Distributed Datasets. Immutable. Basic building block.
RDD: Many ways to create them. Remember transformations (lazy) and actions
Cassandra: Read, write, process as needed. Avoid antipatterns! Don't do unnecessary work
Spark Optimizations: Broadcast Variables, Accumulator Variables, RDD Persistence (cache)
Transformations: map, flatMap, filter, coalesce, join, distinct, union, intersection,
Transformations: reduceByKey, groupByKey, groupByKey, mapPartitions, MapPartitionWithIndex
Actions: count, collect, take, top, countByValue, reduce, fold, aggregate, foreach


_Key-Value Pairs_

Tuple RDD's with a key and a value. Can be any data types Special APIs.
Aggregation – reduceByKey, foldByKey, combineByKey, countByKey
Grouping – groupByKey, cogroup, groupWith, sortByKey (expensive!)
Joins – join, leftOuterJoin, rightOuterJoin, fullOuterJoin, Set Operations –union,intersection,difference


_Partitioning_

Important optimization, partition is fundamental unit, Hashpartitioner, Rangepartitioner, None, Custom
Affected by available resources, external data, transformations, properties of RDDs
defaultParallelism is number of cores, Number of Partitons = Number of tasks (per stage)
Default Behavior: Partitioner=None, sc.defaultParallelism Cassandra or HDFS divides by 64 M
Default Transformation: Partitioner=None (preservers parent), Each transform has specific rule
Default Key-Based: Use various partitioners (Hash), usually size is same as parent except joins


_Partition Tuning_

Set partition size and which partitioner. You will need to tweak this! Don't shuffle or shuffle early
Too few partitions: Less concurrency, data skew, memory pressure, longer failure recovery
Too many partitions: Scheduling takes long, lineage information maintenance
General Recommendation: 100 – 10,000, 2x number of cores, tasks over 100+ ms to complete
Which Partitioner?: Key-Value pair operations. Custom partitioners are also a thing
How to Tune: Application settings, Operation parameters (numTasks), Repartitioning transformations
How to Tune: Explicit repartition(numTasks), coalesce(numPartitions), partitionBy(Partitioner)
Data shuffling: transferring data to achieve same key same partition and desired numPartitions
Data shuffling: Methods and Key-Based, Hash-based became Sort-based (file reduce since 1.2, trivia)
Data shuffling: Expensive! Disk IO, Network traffic, Partitioning, Sorting, Serialization, Compression


_Spark Cassandra Connector_

Count: Do the work in Cassandra instead of Spark (No other spark tasks). CassandraCount()
GroupByKey: Be aware of Cassandra keys and clustering – spanBykey and spanBy
Joining Tables: Joins now in Cassandra!, joinWithCassandraTable() and on(), start lower cardinality
Cassandra-aware partitioning: repartitionByCassandraReplica() – reduce network traffic


_Spark Streaming I_

Microbatches: HDFS, CFS, S3, TCP, Kafka Flume, Kinesis → Receivers → Discretized Streams
Discretized Stream: Dstream becomes four RDDs based on time (different amounts of data) and filter
Architecture: Similar to batch, receiver task gets data continuously from source, streaming context
Streaming Context: Simple socket connections or files, more complex (API), reliable vs unreliable
Transformations vs. Output Operations
Transformations: Stateless and Stateful. Transformations are lazy.
Stateless depend only on own batch – filter, map, flatMap, count, countByValue, reduce, union
Advanced: transform, transformWith(otherDStream, f)
Pair RDD: cogroup, join, leftOuterJoin, rightOuterJoin, combineByKey, groupByKey, reduceByKey
Multiple receivers? – Data from multiple sources or need to scale with multiple executors (tasks)


_Spark Streaming II_

Stateful Transformations: Combine data across batches, updateStateByKey(updateFunction(seq, state))
Stateful Transformations: Needs checkpointing enabled
Window transformations: Transform Dstream to a new Dstream based on window duration and interval
Interval,(number of RDD's to move each time),duration (number of RDDs in window(n\*batchinterval))
Duration – hours too long, do seconds or minutes. Do larger grain separately, interval: app performance
Functions on Dstream: window, countByWindow, countByValueAndWindow, reduceByWindow(inv)
Pair RDD Window Functions: reduceByKeyAndWindow(inv), groupByKeyAndWindow
Output Operations: Triggers computation! Examples: print, saveAs, forEachRDD, saveToCassandra,
Checkpointing and Recovery: Metadata saved in CFS also persists some stream data (can be large)
Persistance: Avoid redundant work. Persist if multiple operations, ensure sufficient memory
Parallelism: Num receivers and Num partitions (tasks), refine empirically


_SparkSQL_

Contexts: CassandraSQLContext, HiveSQLContext, SQLContext. Do SQL-like stuff on C\*!
Dataframes: Similar to RDD's but with named columns, like a table. Create: query, case class, explicity
Accessing Dataframes: printSchema, dTypes, schema, first, index row objects, isNullAt, getInt,
Dataframe Transformations: repartition, coalesce, persist, cache, unpersist, map, flatMap, .rdd, .toJson
Dataframe Actions: (TRIGGERS COMPUTATION) collect, count, first, take, show, foreach
DF Methods: select(c), groupBy, agg, distinct, where, filter, withColumnRenamed, limit, sort, orderBy
DF Binary Transform: join, unionAll, intersect, except, many other supporting functions, READ DOCS
Saving DF to Cassandra: simple – write.format.options.save
Querying Cassandra: setKeyspace, sql, registerTempTable, explain
Efficient SQL: fastest is doable in cqlsh, predicate push down,

_Expert Concepts_ (TODO)

_Final Notes_

Current Release: 2.3.0 as of February 28th
Datasets and Dataframes came with 2.0
RDDs, Dataframes, and Datasets: RDDs are the OG. Good for unstructured low-level jams
Dataframes and Datasets are part of the same API. Datasets are strongly typed. Dataframes aren't.
Python and R use untyped Dataframes (no compile-time type safety in those languages)
Java uses strongly typed datasets, Scala can use both
Dataset and Dataframe API's use less memory, Tungsten encoder serializes JVM objects
