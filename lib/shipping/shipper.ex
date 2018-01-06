defmodule Shipping.Shipper do
  @moduledoc ~S"""
  Public interface for shippers.
  """

  alias Shipping.Shipper.Commands.CreateLoad
  alias Shipping.Shipper.Events.LoadCreated

  defmodule Load do
    @fields [
      :uuid,
      :shipper_id,
      :number_of_trips,
      :car_type,
      :start_date_millis
    ]

    @enforce_keys @fields
    defstruct @fields

    def fields, do: @fields
  end

  @doc "Creates a new load"
  @spec create_load(%CreateLoad{}) :: {:ok, %LoadCreated{}}
  def create_load(%CreateLoad{} = command) do
    # TODO: Validations
    load = struct!(Load, Map.from_struct(command))
    event = load_created_event(load)
    {:ok, event}
  end

  defp load_created_event(load) do
    params =
      load
      |> Map.from_struct()
      |> Map.put(:timestamp, :os.system_time(:milli_seconds))

    struct!(LoadCreated, params)
  end
end
