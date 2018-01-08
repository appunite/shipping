defmodule Shipping.Driver.Load do
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
