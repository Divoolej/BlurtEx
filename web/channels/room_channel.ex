defmodule BlurtEx.RoomChannel do
  use BlurtEx.Web, :channel

  def join("room:lobby", _, socket) do
    send self(), :after_join
    { :ok, socket }
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", []
    { :noreply, socket }
  end

  def handle_in("message:new", message, socket) do
    broadcast! socket, "message:new", %{
      user: socket.assigns.user,
      body: message,
      timestamp: :os.system_time(:milli_seconds)
    }
    { :noreply, socket }
  end
end
