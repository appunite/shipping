defmodule Shipping.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Shipping.Shipper.Supervisor, []),
      supervisor(Shipping.PubSub.Supervisor, [])
    ], strategy: :one_for_one, name: Shipping.Supervisor)
  end
end
