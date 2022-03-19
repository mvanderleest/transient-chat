defmodule TransientChatWeb.PageLive do
  use TransientChatWeb, :live_view
  require Logger

  def mount(_params,_session,socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end

  def handle_event("random-room",_params,socket) do
    random_slug = "/" <> MnemonicSlugs.generate_slug(4)
    Logger.info(random_slug)
    {:noreply, push_redirect(socket, to: random_slug)}
  end

end
