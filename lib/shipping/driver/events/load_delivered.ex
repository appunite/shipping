defmodule Shipping.Driver.Events.LoadDelivered do
  @fields [:uuid, :load_id, :timestamp]

  @enforce_keys @fields
  defstruct @fields
end
