defmodule TransientChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TransientChatWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TransientChat.PubSub},
      # Start the Endpoint (http/https)
      TransientChatWeb.Endpoint,
      TransientChatWeb.Presence
      # Start a worker by calling: TransientChat.Worker.start_link(arg)
      # {TransientChat.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TransientChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TransientChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
