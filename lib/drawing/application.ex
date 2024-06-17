defmodule Drawing.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DrawingWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:drawing, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Drawing.PubSub},
      # Start a worker by calling: Drawing.Worker.start_link(arg)
      # {Drawing.Worker, arg},
      # Start to serve requests, typically the last entry
      DrawingWeb.Endpoint,
      {Drawing.Image, name: Drawing.TheImage}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Drawing.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DrawingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
