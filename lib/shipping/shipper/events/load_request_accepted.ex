defmodule Shipping.Shipper.Events.LoadRequestAccepted do
  @fields [
    :uuid,
    :load_id,
    :timestamp
  ]

  @enforce_keys @fields
  defstruct @fields
end
