defmodule Shipping.PubSub.TopicSupervisor do
  use Supervisor

  @name __MODULE__

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    children = [
      worker(Shipping.PubSub.Topic, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
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
