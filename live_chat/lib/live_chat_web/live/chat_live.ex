defmodule LiveChatWeb.ChatLive do
  use LiveChatWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :chat_log, [])}
  end

  def handle_event("chat", %{"c" => ""}, socket) do
    {:noreply, assign(socket, :chat_log, [socket.assigns.chat_log])}
  end

  def handle_event("chat", %{"c" => chat}, socket) do
    {:noreply, assign(socket, :chat_log, socket.assigns.chat_log ++ [chat])}
  end
end
