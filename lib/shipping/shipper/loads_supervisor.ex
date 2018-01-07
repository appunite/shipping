defmodule Shipping.Shipper.LoadsSupervisor do
  use Supervisor

  alias Shipping.Shipper.LoadServer

  @name __MODULE__

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    children = [
      supervisor(LoadServer, []),
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
