defmodule TransientChatWeb.RoomLive do
  use TransientChatWeb, :live_view
  require Logger

  def mount(%{"id" => room_id},_session,socket) do
    topic = "room:" <> room_id
    username = MnemonicSlugs.generate_slug(2)

    if connected?(socket) do
      TransientChatWeb.Endpoint.subscribe(topic)
      TransientChatWeb.Presence.track(self(), topic, username, %{})
    end

    {:ok,
    assign(socket,
      room_id: room_id,
      topic: topic,
      username: username,
      message: "",
      messages: [],
      user_list: [],
      users_count: 0,
      temporary_assigns: [messages: []]
    )}
  end

  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    message = %{uuid: UUID.uuid4(), content: message, username: socket.assigns.username}
    TransientChatWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", message)
    {:noreply, assign(socket, message: "")}
  end

  def handle_event("form_update", %{"chat" => %{"message" => message}}, socket) do
    {:noreply, assign(socket, message: message)}
  end

  def handle_info(%{event: "new-message", payload: message}, socket) do
    {:noreply, assign(socket, messages: [message])}
  end

  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    join_messages =
      joins
      |> Map.keys()
      |> Enum.map(fn username ->
        %{ type: :system, uuid: UUID.uuid4(), content: "#{username} joined"}
    end)

    leave_messages =
      leaves
      |> Map.keys()
      |> Enum.map(fn username ->
        %{ type: :system, uuid: UUID.uuid4(), content: "#{username} left"}
    end)

    user_list =
      TransientChatWeb.Presence.list(socket.assigns.topic)
      |> Map.keys()

    users_count =
      user_list
      |> length()

    {:noreply, assign(socket, messages: join_messages ++ leave_messages, user_list: user_list, users_count: users_count)}
  end

  def display_message(%{type: :system, uuid: uuid, content: content}) do
    ~E"""
      <li id="<%= uuid  %>">
        <div class="flex space-x-3">
          <div>
            <div class="mt-1 text-sm text-gray-700">
              <p><em><%= content %></em></p>
            </div>
          </div>
        </div>
      </li>
    """
  end

  def display_message(%{uuid: uuid, content: content, username: username}) do
    ~E"""
      <li id="<%= uuid  %>">
        <div class="flex space-x-3">
          <div>
            <div class="text-sm">
              <p><span class="font-medium text-gray-900"><%= username %></span>: <span class="text-gray-700"><%= content %></span></p>
            </div>
          </div>
        </div>
      </li>
    """
  end
end
