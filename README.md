# vagrant_network_multivendor_access
Vagrantfile for setting up an Arista, Juniper, and Cumulus Linux campus network

```
 Aggregation MLAG Topology


                                  +---------------+         +---------------+
                         cumulus  | aggregation01 |         | aggregation02 |
                                  +---------------+         +---------------+
                                     |              \     /            |
                                     |                \ /              |
                                     |                / \              |
                                     |              /     \            |
                                  +---------------+         +---------------+
                          arista  |    spine01    |---------|    spine02    |
                                  +---------------+         +---------------+
                                  /  |      \       \      /        /  |  \
                              /      |         \      / \       /      |     \
                          /          |          / \         /\         |        \
                      /              |     /         \  /         \    |           \
                  /                  |/            /     \            \|              \
              /                  /   |         /            \          |   \             \
          /                 /        |     /                   \       |         \          \
          +--------------+        +---------------+         +---------------+        +--------------+
 juniper  |    leaf01    |        |    leaf02     |         |    leaf03     |        |    leaf04    |
          +--------------+        +---------------+         +---------------+        +--------------+
```
