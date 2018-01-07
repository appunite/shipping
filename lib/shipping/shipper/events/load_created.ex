defmodule Shipping.Shipper.Events.LoadCreated do
  @fields [
    :uuid,
    :shipper_id,
    :number_of_trips,
    :car_type,
    :start_date_millis,
    :lat,
    :lng,
    :timestamp
  ]

  @enforce_keys @fields
  defstruct @fields
end
