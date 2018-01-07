defmodule Shipping.Driver.Events.LoadRequestSent do
  @fields [:uuid, :driver_id, :load_id, :timestamp]

  @enforce_keys @fields
  defstruct @fields
end
