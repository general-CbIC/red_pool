defmodule RedPoolTest do
  use ExUnit.Case
  doctest RedPool

  test "cluster setup check" do
    {:ok, node_0} = Redix.start_link(host: "localhost", port: 7010, password: "bitnami")
    {:ok, node_1} = Redix.start_link(host: "localhost", port: 7011, password: "bitnami")
    {:ok, node_2} = Redix.start_link(host: "localhost", port: 7012, password: "bitnami")
    {:ok, node_3} = Redix.start_link(host: "localhost", port: 7013, password: "bitnami")
    {:ok, node_4} = Redix.start_link(host: "localhost", port: 7014, password: "bitnami")
    {:ok, node_5} = Redix.start_link(host: "localhost", port: 7015, password: "bitnami")

    assert {:ok, cluster_nodes} = Redix.command(node_0, ["CLUSTER", "NODES"])
    cluster_nodes_rows = String.split(cluster_nodes, "\n", trim: true)
    assert Enum.count(cluster_nodes_rows) == 6
    assert Enum.count(cluster_nodes_rows, fn row -> String.contains?(row, "connected") end) == 6
    assert Enum.count(cluster_nodes_rows, fn row -> String.contains?(row, "master") end) == 3
    assert Enum.count(cluster_nodes_rows, fn row -> String.contains?(row, "slave") end) == 3

    set_results =
      [node_0, node_1, node_2, node_3, node_4, node_5]
      |> Stream.map(fn node -> Redix.command(node, ["SET", "test_key", "value"]) end)
      |> Enum.map(fn
        {:ok, "OK"} -> :ok
        {:error, _} -> :error
      end)

    assert Enum.count(set_results, fn result -> result == :ok end) == 1
    assert Enum.count(set_results, fn result -> result == :error end) == 5

    get_results =
      [node_0, node_1, node_2, node_3, node_4, node_5]
      |> Stream.map(fn node -> Redix.command(node, ["GET", "test_key"]) end)
      |> Enum.map(fn
        {:ok, "value"} -> :ok
        {:error, _} -> :error
      end)

    assert Enum.count(get_results, fn result -> result == :ok end) == 1
    assert Enum.count(get_results, fn result -> result == :error end) == 5
  end
end
