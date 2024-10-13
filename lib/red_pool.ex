defmodule RedPool do
  @moduledoc """
  Documentation for `RedPool`.
  """

  use GenServer, shutdown: :infinity

  @type red_pool_option() :: {:pool_name, GenServer.name()}

  @spec start(list(red_pool_option())) :: GenServer.on_start()
  def start(opts) do
    pool_name = Keyword.fetch!(opts, :pool_name)
    GenServer.start(__MODULE__, opts, name: pool_name)
  end

  @spec start_link(list()) :: GenServer.on_start()
  def start_link(opts) do
    pool_name = Keyword.fetch!(opts, :pool_name)
    GenServer.start_link(__MODULE__, opts, name: pool_name)
  end

  @spec child_spec(list()) :: Supervisor.child_spec()
  def child_spec(opts) do
    pool_name = Keyword.fetch!(opts, :pool_name)
    %{id: pool_name, start: {RedPool, :start_link, [opts]}}
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
