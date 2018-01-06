defmodule Shipping.Shipper.Events.LoadCreated do
  @fields [:timestamp | Shipping.Shipper.Load.fields()]

  @enforce_keys @fields
  defstruct @fields
end
