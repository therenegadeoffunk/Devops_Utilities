**CASSANDRA NOTES**

_Deployment_

1. For bootstrap, nodes need four parameters in their config file:
 - cluster\_name, rpc\_address, listen\_address, seeds
2. Use VNODES if you aren't already. They make things way easier.
3. Follow procedure for replacing nodes (cassandra-env file). Use decomission to shrink cluster.
4. Use nodetool removenode for dead nodes.


_Maintenance_

1. Run repairs weekly if you can
2. Never manually compact. Also, try to avoid changing replication factor.
3. Use snapshots and put them somewhere. Remember nodetool refresh and preserve the schema
4. Rebuild index needs to be run on all nodes


_Configuration_

1. No swap, keep 50% disk if using size-tiered compaction
2. A lot depends on whether your workload is read-heavy or write-heavy. Figure that out.
3. Make sure auto\_snapshot is enabled
4. Use separate SSL certs for client-node and node-node
5. Use authentication and superusers (ACL?). Increase replication of system\_auth keyspace
6. No out-of-the-box data at rest encryption
7. Multi-DC: At least one node from each DC as a seed
8. Multi-DC: Remember replication factor is set per DC. Remember consistency level 'local'.


_Tuning_

1. Workload, Data Model, Environment (OS, JVM, Cassandra, other software), Hardware
2. Latency and Throughput – Set a goal (Read latency, transactions per second, etc.)
3. Parameters: Read/Write, Query, Latency, Throughput, Size, Duration, Scope
4. Cache the shit out of everything. SSD's and lots of RAM = Awesome sauce
5. Data model is everything → Bad: Lots of tombstones, small / big rows, hotspots, bad indexes
6. Active vs. Passive Tuning (U.S.E.) Always investigate dropped messages
7. Look at Read Repair stats to understand cluster consistency
8. Nodetool cfstats is your friend. Look at number of SSTables, disk usage, read vs write, etc.
9. Increase RAM for bloom filter false positive reduction. Also, reading lots of tombstones=bad
10. Look at compacted partition stat differences to identify hotspots (mean and max difference)
11. Use 'desc table' to see tunables (per-table tuning – caching, bloom filter, etc.)
12. Tune compression ratio by picking different algorithm (may use more CPU)
13. Nodetool cfhistograms to see if reads use lots of SSTables (compactions getting behind)
14. Common Bottlenecks: Bad JVM Config // Bad Hardware // Bad Memory Caching // CPU
15. JVM GC Tuning: Look at Java version and GC version (G1 is good on Java 8)
16. CPU Tuning: Encryption, compression, and GC's add load. Look at metrics. Scale out.
17. Use SSD's. Enable 'trickle\_fsync', reduce partition size by increasing concurrent reads and lowering  index\_interval and column\_index\_size\_in\_kb
18. Improve read latencies by throttling down compaction (compaction\_throughput\_in\_mb\_per\_sec)
19. Nodetool proxyhistograms for full read latency. Also use readahead 8 for SSD's.
20. Use cql tracing to distinguish between long queries and bad disks (lots of SSTables, tombstones, etc)
21. Increase compaction memory to speed it up. Can also increase JVM but watch for GC pauses
22. Compaction strategy is PER TABLE


TUNING EASY WINS:

Increase flush writers // Decrease concurrent compactors (2 or 1) // Increase concurrent reads or writes // Make Cassandra use OS cache // Increase compaction\_throughput // Increase streaming\_throughput

OTHER WINS:

Make data model time series // No more than 500 tables // Stay under 100,000 columns or 100 MB // Use token aware load balancing //


Data Model

1. Try to minimize deletes. Do NOT use Cassandra as a queue.
2. Cardinalities:

 One-to-One (Movie – First Showing) – Use either for uniqueness
 One-to-Many (User -uploads- video) – Use the 'many' for primary key
 Many-to-Many (Actor – Video) – Combine both for primary key

3. Inheritance relationships, disjointedness
