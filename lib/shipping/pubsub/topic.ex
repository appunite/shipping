defmodule Shipping.PubSub.Topic do
  use GenServer

  require Logger

  defmodule State do
    defstruct [:topic, subscribers: []]
  end

  @spec start_link(String.t) :: {:ok, pid}
  def start_link(topic) do
    GenServer.start_link(__MODULE__, topic, name: name(topic))
  end

  @spec subscribe(String.t, pid) :: :ok
  def subscribe(topic, pid), do: GenServer.cast(name(topic), {:subscribe, pid})

  @spec publish(String.t, term) :: :ok
  def publish(topic, msg), do: GenServer.cast(name(topic), {:publish, msg})

  def init(topic) do
    {:ok, %State{topic: topic, subscribers: []}}
  end

  def handle_info({:DOWN, _ref, _, pid, _}, state) do
    new_subscribers = Enum.reject(state.subscribers, &(&1 == pid))
    {:noreply, %State{state | subscribers: new_subscribers}}
  end

  def handle_info(msg, state) do
    Logger.info("PubSub.Topic received unexpected message: #{inspect msg}")

    {:noreply, state}
  end

  def handle_cast({:subscribe, pid}, state) do
    new_state = %{state | subscribers: Enum.uniq([pid | state.subscribers])}
    Process.monitor(pid)

    {:noreply, new_state}
  end

  def handle_cast({:publish, message}, state) do
    Enum.each(state.subscribers, fn pid -> send(pid, message) end)

    {:noreply, state}
  end

  defp name(topic) do
    {:via, Registry, {:pubsub_registry, topic}}
  end
end
