defmodule Shipping.Shipper.LoadServer do
  use GenServer

  alias Shipping.Shipper
  alias Shipping.Shipper.Load
  alias Shipping.Shipper.Commands.CreateLoad

  alias Shipping.Driver.Events.LoadRequestSent
  alias Shipping.Driver.Events.LoadPickedUp
  alias Shipping.Driver.Events.LoadDelivered

  ## API

  def create_load(%CreateLoad{} = command) do
    GenServer.start_link(__MODULE__, command)
  end

  def get_load_requests(pid) do
    GenServer.call(pid, :get_load_requests)
  end

  def accept_load_request(pid, request_uuid) do
    GenServer.cast(pid, {:accept_load_request, request_uuid})
  end

  ## CALLBACKS

  def init(%CreateLoad{} = command) do
    {:ok, event} = Shipper.create_load(command)
    load = Load.from_event(event)
    {:ok, load}
  end

  def handle_call(:get_load_requests, _from, load) do
    requests = Shipper.get_load_requests(load)
    {:reply, requests, load}
  end

  def handle_cast({:accept_load_request, request_uuid}, load) do
    {:ok, event} = Shipper.accept_load_request(load, request_uuid)

    {:noreply, load}
  end

  def handle_info(%LoadRequestSent{} = event, load) do
    {[], new_load} = Shipper.handle_load_request(load, event)

    {:noreply, new_load}
  end

  def handle_info(%LoadPickedUp{} = event, load) do
    {[], new_load} = Shipper.handle_load_pickup(load, event)

    {:noreply, new_load}
  end

  def handle_info(%LoadDelivered{} = event, load) do
    {[], new_load} = Shipper.handle_load_delivery(load, event)

    {:noreply, new_load}
  end
end