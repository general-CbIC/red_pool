# How it works

It is a scheme of interaction with Redis through the RedPool library when the Redis cluster consists of three working nodes, and the library is configured so that two permanent connections are open for each node.

```mermaid
graph LR
  subgraph RedPool
    red_pool_interfaces["RedPool interfaces"]
  end

  subgraph Poolex
    subgraph Connections Pool 1
      worker_1_conn_1
      worker_1_conn_2
    end
    subgraph Connections Pool 2
      worker_2_conn_1
      worker_2_conn_2
    end
    subgraph Connections Pool 3
      worker_3_conn_1
      worker_3_conn_2
    end
  end

  subgraph redis_cluster["Redis Cluster"]
    worker_1
    worker_2
    worker_3
  end

  you --> red_pool_interfaces
  red_pool_interfaces --> Poolex
  Poolex --> redis_cluster
```

When the right worker was chosen the first time.

```mermaid
sequenceDiagram
  You ->> RedPool: execute some insert command
  RedPool ->> State: get pool id for worker (RoundRobin)
  State -->> RedPool: pool id
  RedPool ->> Pool: run command
  Pool ->> Redis: run command
  Redis -->> Pool: result
  Pool -->> RedPool: result
  RedPool -->> You: result
```

When Redis informed that it is necessary to record through another worker.

```mermaid
sequenceDiagram
  You ->> RedPool: execute some insert command
  RedPool ->> State: get pool id for worker (RoundRobin)
  State -->> RedPool: pool id
  RedPool ->> Pool: run command
  Pool ->> Redis: run command
  Redis -->> Pool: MOVED port
  Pool -->> RedPool: MOVED port
  RedPool ->> State: Get pool id by port
  State -->> RedPool: pool id
  RedPool ->> Pool: run command
  Pool ->> Redis: run command
  Redis -->> Pool: result
  Pool -->> RedPool: result
  RedPool -->> You: result
```
