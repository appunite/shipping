defmodule Shipping.Driver.LoadStorageWorker do
  use GenServer

  alias Shipping.Shipper.Events.LoadCreated
  alias Shipping.Driver.LoadStorage

  @name __MODULE__

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def init([]) do
    LoadStorage.init()

    Shipping.PubSub.subscribe("load_created", self())

    {:ok, []}
  end

  def handle_info(%LoadCreated{} = event, state) do
    LoadStorage.store_load(event)

    {:noreply, state}
  end
end
