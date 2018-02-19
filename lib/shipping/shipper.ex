defmodule Shipping.Shipper do
  @moduledoc ~S"""
  Public interface for shippers.
  """

  alias Shipping.Shipper.Commands.CreateLoad
  alias Shipping.Shipper.Events.LoadCreated
  alias Shipping.Shipper.Events.LoadRequestAccepted
  alias Shipping.Shipper.Events.LoadCompleted

  alias Shipping.Driver.Events.LoadRequestSent
  alias Shipping.Driver.Events.LoadPickedUp
  alias Shipping.Driver.Events.LoadDelivered

  defmodule Load do
    @fields [
      :uuid,
      :shipper_id,
      :number_of_trips,
      :car_type,
      :start_date_millis,
      :lat,
      :lng
    ]

    @enforce_keys @fields
    defstruct @fields
  end

  defmodule Load do
    @fields [
      :uuid,
      :shipper_id,
      :number_of_trips,
      :car_type,
      :start_date_millis,
      :lat,
      :lng,
      :driver_requests,
      :picked_up,
      :delivered
    ]

    @enforce_keys @fields
    defstruct @fields

    def fields, do: @fields

    def from_event(%LoadCreated{} = event) do
      params =
        event
        |> Map.from_struct()
        |> Map.delete(:timestamp)
        |> Map.put(:driver_requests, [])
        |> Map.put(:picked_up, [])
        |> Map.put(:delivered, [])

      struct!(__MODULE__, params)
    end
  end

  @doc "Creates a new load"
  @spec create_load(%CreateLoad{}) :: {:ok, %LoadCreated{}}
  def create_load(%CreateLoad{} = command) do
    # TODO: Validations
    params =
      command
      |> Map.from_struct()
      |> Map.put(:timestamp, :os.system_time(:milli_seconds))

    {:ok, struct!(LoadCreated, params)}
  end

  @doc "Handles a load request from a driver"
  @spec handle_load_request(%Load{}, %LoadRequestSent{}) :: %Load{}
  def handle_load_request(%Load{} = load, %LoadRequestSent{} = request) do
    requests = [request | load.driver_requests]
    new_load = %Load{load | driver_requests: requests}
    events = []

    {events, new_load}
  end

  @doc "Returns list of received load requests"
  @spec get_load_requests(%Load{}) :: [%LoadRequestSent{}]
  def get_load_requests(%Load{} = load), do: load.driver_requests

  @doc "Accepts a load request from a driver"
  @spec accept_load_request(%Load{}, String.t()) :: {:ok, %LoadRequestAccepted{}}
  def accept_load_request(%Load{} = load, request_uuid) do
    request = Enum.find(load.driver_requests, &(&1.uuid == request_uuid))

    event = %LoadRequestAccepted{
      load_id: load.uuid,
      uuid: request.uuid,
      timestamp: :os.system_time(:milli_seconds)
    }

    {:ok, event}
  end

  @doc "Handles LoadPickedUp event from driver"
  @spec handle_load_pickup(%Load{}, %LoadPickedUp{}) :: %Load{}
  def handle_load_pickup(%Load{uuid: load_uuid} = load, %LoadPickedUp{load_id: load_uuid} = event) do
    picked_up = [event | load.picked_up]
    new_load = %Load{load | picked_up: picked_up}
    events = []

    {events, new_load}
  end

  @doc "Handles LoadDelivered event from driver"
  @spec handle_load_delivery(%Load{}, %LoadDelivered{}) :: %Load{}
  def handle_load_delivery(
        %Load{uuid: load_uuid} = load,
        %LoadDelivered{load_id: load_uuid} = event
      ) do
    delivered = [event | load.delivered]
    new_load = %Load{load | delivered: delivered}

    events =
      if length(new_load.delivered) == load.number_of_trips do
        [%LoadCompleted{uuid: load.uuid, shipper_id: load.shipper_id, timestamp: :os.timestamp()}]
      else
        []
      end

    {events, new_load}
  end
end
