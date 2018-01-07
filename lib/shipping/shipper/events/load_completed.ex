defmodule Shipping.Shipper.Events.LoadCompleted do
  @fields [
    :uuid,
    :shipper_id,
    :timestamp
  ]

  @enforce_keys @fields
  defstruct @fields
end
