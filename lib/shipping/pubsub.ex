defmodule Shipping.PubSub do
  @type topic :: String.t()

  alias Shipping.PubSub.TopicSupervisor
  alias Shipping.PubSub.Topic

  @spec subscribe(topic, pid) :: :ok
  def subscribe(topic, pid) when is_binary(topic) do
    TopicSupervisor.ensure_started(topic)
    Topic.subscribe(topic, pid)
  end

  @spec publish(topic, term) :: :ok
  def publish(topic, message) do
    Topic.publish(topic, message)
  end
end
