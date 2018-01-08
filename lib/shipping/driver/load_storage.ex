defmodule Shipping.Driver.LoadStorage do
  alias Shipping.Shipper.Events.LoadCreated
  alias Shipping.Driver.Load

  def init() do
    table = :ets.new(:shipper_loads, [:set, access(), :named_table])
  end

  def store_load(%LoadCreated{} = event) do
    load = %Load{
      uuid: event.uuid,
      shipper_id: event.shipper_id,
      number_of_trips: event.number_of_trips,
      car_type: event.car_type,
      start_date_millis: event.start_date_millis,
      lat: event.lat,
      lng: event.lng
    }

    current_loads =
      case :ets.lookup(:shipper_loads, "all") do
        ["all", loads] -> loads
        _ -> []
      end

    all_loads = [load | current_loads]

    :ets.insert(:shipper_loads, {"all", all_loads})
    :ets.insert(:shipper_loads, {event.uuid, load})
  end

  def fetch_by_id(load_uuid) do
    case :ets.lookup(:shipper_loads, load_uuid) do
      [{^load_uuid, load}] -> {:ok, load}
      _ -> {:error, :not_found}
    end
  end

  def fetch_all do
    case :ets.lookup(:shipper_loads, "all") do
      [{"all", loads}] -> loads
      _ -> []
    end
  end

  defp access() do
    if Mix.env() == :test, do: :public, else: :protected
  end
end
