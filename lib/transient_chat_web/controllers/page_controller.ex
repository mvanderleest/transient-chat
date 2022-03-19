defmodule TransientChatWeb.PageController do
  use TransientChatWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
