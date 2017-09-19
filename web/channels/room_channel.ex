defmodule BlurtEx.RoomChannel do
  use BlurtEx.Web, :channel
  alias BlurtEx.Presence
  alias BlurtEx.User

  intercept ["presence_diff"]

  def join("room:lobby", _, socket) do
    send self(), :after_join
    { :ok, socket }
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user.username, %{
      online_at: :os.system_time(:milli_seconds)
    })
    push socket, "presence_state", Presence.list(socket)
    { :noreply, socket }
  end

  def handle_in("message:new", message, socket) do
    new_message = if message == %{}, do: "", else: message
    modified_at = DateTime.utc_now
    broadcast! socket, "message:new", %{
      user_id: socket.assigns.user.id,
      username: socket.assigns.user.username,
      body: new_message,
      timestamp: :os.system_time(:milli_seconds),
    }
    changeset = Ecto.Changeset.change(socket.assigns.user, %{ message: new_message, modified_at: modified_at })
    Repo.update!(changeset)
    { :noreply, socket }
  end

  def handle_out("presence_diff", msg, socket) do
    push socket, "presence_diff", msg
    {:noreply, socket}
  end
end
