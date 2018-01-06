defmodule Shipping.ShipperTest do
  use ExUnit.Case, async: true

  alias Shipping.Shipper
  alias Shipping.Shipper.Commands.CreateLoad
  alias Shipping.Shipper.Events.LoadCreated

  test "create_load returns an event" do
    command = %CreateLoad{
      uuid: "uuid",
      shipper_id: "shipper_id",
      car_type: :small,
      number_of_trips: 5,
      start_date_millis: 1000
    }

    {:ok, event} = Shipper.create_load(command)

    assert %LoadCreated{
      uuid: "uuid",
      shipper_id: "shipper_id",
      car_type: :small,
      number_of_trips: 5,
      start_date_millis: 1000,
      timestamp: _
    } = event
  end
end
