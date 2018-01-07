defmodule Shipping.Driver.Events.LoadPickedUp do
  @fields [:uuid, :load_request_id, :driver_id, :load_id, :timestamp]

  @enforce_keys @fields
  defstruct @fields
end
