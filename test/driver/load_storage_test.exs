defmodule Shipping.Driver.LoadStorageTest do
  use ExUnit.Case, async: false

  alias Shipping.Driver.LoadStorage

  @event %Shipping.Shipper.Events.LoadCreated{
    car_type: :small,
    lat: 10.0,
    lng: 10.0,
    number_of_trips: 5,
    shipper_id: "shipper_id",
    start_date_millis: 1000,
    timestamp: 1_515_403_696_862,
    uuid: "uuid"
  }

  test "stores the load after receiving the event" do
    LoadStorage.store_load(@event)
    assert [%Shipping.Driver.Load{}] = LoadStorage.fetch_all()
  end

  test "load can be fetched by uuid" do
    LoadStorage.store_load(@event)
    assert {:ok, %Shipping.Driver.Load{}} = LoadStorage.fetch_by_id(@event.uuid)
  end
end
