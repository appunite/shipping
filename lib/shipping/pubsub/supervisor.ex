defmodule Shipping.PubSub.Supervisor do
  use Supervisor

  @name __MODULE__

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    children = [
      supervisor(Registry, [:unique, :pubsub_registry]),
      supervisor(Shipping.PubSub.TopicSupervisor, [])
    ]

    supervise(children, strategy: :one_for_one)
  end

  def ensure_started(topic) do
    case Registry.lookup(:pubsub_registry, topic) do
      [{pid, _}] when is_pid(pid) ->
        {:ok, pid}
      _ ->
        Supervisor.start_child(@name, [topic])
    end
  end
end
