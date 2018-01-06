defmodule Shipping.Mixfile do
  use Mix.Project

  def project do
    [
      app: :shipping,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:uuid, "~> 1.1"}
    ]
  end
end
