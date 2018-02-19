defmodule Shipping.Driver.DriverHandlerTest do
  use ExUnit.Case, async: true

  alias Shipping.Driver.DriverHandler

  alias Shipping.Driver.Events.LoadRequestSent

  test "send_load_request returns correct event" do
    {:ok, event} = DriverHandler.send_load_request("driver_id", "load_id")

    assert %LoadRequestSent{driver_id: "driver_id", load_id: "load_id", uuid: _, timestamp: _} =
             event
  end
end
