defmodule Shipping.Shipper.Commands.CreateLoad do
  @fields Shipping.Shipper.Load.fields()

  @enforce_keys @fields
  defstruct @fields
end
