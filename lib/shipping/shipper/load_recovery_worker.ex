defmodule Shipping.Shipper.LoadRecoveryWorker do
  @moduledoc ~S"""
  After starting, this worker loads all loads saved on disk and starts
  the process for each of them.
  """
  use GenServer

  alias Shipping.Shipper.LoadServer

  @name __MODULE__

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def init([]) do
    "shipper_loads/*"
    |> Path.wildcard()
    |> Enum.each(fn filename ->
      {:ok, encoded} = File.read(filename)
      load = :erlang.binary_to_term(encoded)
      LoadServer.restore_load(load)
    end)

    {:ok, []}
  end
end
