defmodule RedPool do
  @moduledoc """
  Documentation for `RedPool`.
  """

  use GenServer, shutdown: :infinity

  # TODO: describe options type and write spec
  def start(opts) do
    # TODO: change temporary name `RedPool` to configurable
    GenServer.start(__MODULE__, opts, name: RedPool)
  end

  # TODO: describe options type and write spec
  def start_link(opts) do
    # TODO: change temporary name `RedPool` to configurable
    GenServer.start_link(__MODULE__, opts, name: RedPool)
  end

  # TODO: describe options type and write spec
  def child_spec(opts) do
    # TODO: change temporary name `RedPool` to configurable
    %{id: RedPool, start: {RedPool, :start_link, [opts]}}
  end

  @impl GenServer
  def init(_opts) do
    Process.flag(:trap_exit, true)

    {:ok, %{}}
  end

  @impl GenServer
  def terminate(_reason, _state) do
    # Nothing to do yet

    :ok
  end
end
