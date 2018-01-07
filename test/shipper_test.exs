defmodule Shipping.ShipperTest do
  use ExUnit.Case, async: true

  alias Shipping.Shipper
  alias Shipping.Shipper.Load
  alias Shipping.Shipper.Commands.CreateLoad

  alias Shipping.Shipper.Events.LoadCreated
  alias Shipping.Shipper.Events.LoadRequestAccepted
  alias Shipping.Shipper.Events.LoadCompleted

  alias Shipping.Driver.Events.LoadRequestSent
  alias Shipping.Driver.Events.LoadPickedUp
  alias Shipping.Driver.Events.LoadDelivered

  test "create_load returns a correct event" do
    command = %CreateLoad{
      uuid: "uuid",
      shipper_id: "shipper_id",
      car_type: :small,
      number_of_trips: 5,
      start_date_millis: 1000,
      lat: 10.0,
      lng: 10.0
    }

    {:ok, event} = Shipper.create_load(command)

    assert %LoadCreated{
             uuid: "uuid",
             shipper_id: "shipper_id",
             car_type: :small,
             number_of_trips: 5,
             start_date_millis: 1000,
             lat: 10.0,
             lng: 10.0,
             timestamp: _
           } = event
  end

  test "handle_load_request saves request in the load" do
    command = %CreateLoad{
      uuid: "load_uuid",
      shipper_id: "shipper_id",
      car_type: :small,
      number_of_trips: 5,
      start_date_millis: 1000,
      lat: 10.0,
      lng: 10.0
    }

    {:ok, event} = Shipper.create_load(command)
    load = Load.from_event(event)

    load_request_event = %LoadRequestSent{
      uuid: "request_uuid",
      load_id: "load_uuid",
      driver_id: "driver_uuid",
      timestamp: 10
    }

    assert {[], %{driver_requests: [^load_request_event]}} =
             Shipper.handle_load_request(load, load_request_event)
  end

  test "accept_load_request returns a correct event" do
    command = %CreateLoad{
      uuid: "load_uuid",
      shipper_id: "shipper_id",
      car_type: :small,
      number_of_trips: 5,
      start_date_millis: 1000,
      lat: 10.0,
      lng: 10.0
    }

    {:ok, event} = Shipper.create_load(command)
    load = Load.from_event(event)

    load_request_event = %LoadRequestSent{
      uuid: "request_uuid",
      load_id: "load_uuid",
      driver_id: "driver_uuid",
      timestamp: 10
    }

    {[], load_with_request} = Shipper.handle_load_request(load, load_request_event)

    {:ok, event} = Shipper.accept_load_request(load_with_request, "request_uuid")

    assert %LoadRequestAccepted{
             uuid: "request_uuid",
             load_id: "load_uuid",
             timestamp: _
           } = event
  end

  describe "handle_load_pickup" do
    test "events with correct load_id" do
      command = %CreateLoad{
        uuid: "load_uuid",
        shipper_id: "shipper_id",
        car_type: :small,
        number_of_trips: 5,
        start_date_millis: 1000,
        lat: 10.0,
        lng: 10.0
      }

      {:ok, event} = Shipper.create_load(command)
      load = Load.from_event(event)

      pick_up_event = %LoadPickedUp{
        uuid: "uuid",
        driver_id: "driver_id",
        load_id: "load_uuid",
        load_request_id: "load_request_id",
        timestamp: 1000
      }

      assert {[], %Load{picked_up: [^pick_up_event]}} =
               Shipper.handle_load_pickup(load, pick_up_event)
    end
  end

  describe "handle_load_delivery" do
    test "updates delivered list" do
      command = %CreateLoad{
        uuid: "load_uuid",
        shipper_id: "shipper_id",
        car_type: :small,
        number_of_trips: 5,
        start_date_millis: 1000,
        lat: 10.0,
        lng: 10.0
      }

      {:ok, event} = Shipper.create_load(command)
      load = Load.from_event(event)

      deliver_event = %LoadDelivered{
        uuid: "uuid",
        load_id: "load_uuid",
        timestamp: 1000
      }

      assert {[], %Load{delivered: [^deliver_event]}} =
        Shipper.handle_load_delivery(load, deliver_event)
    end

    test "returns LoadCompleted event when all trips are done" do
      command = %CreateLoad{
        uuid: "load_uuid",
        shipper_id: "shipper_id",
        car_type: :small,
        number_of_trips: 1,
        start_date_millis: 1000,
        lat: 10.0,
        lng: 10.0
      }

      {:ok, event} = Shipper.create_load(command)
      load = Load.from_event(event)

      deliver_event = %LoadDelivered{
        uuid: "uuid",
        load_id: "load_uuid",
        timestamp: 1000
      }

      assert {[%LoadCompleted{uuid: "load_uuid"}], _new_load} =
        Shipper.handle_load_delivery(load, deliver_event)
    end
  end
end
