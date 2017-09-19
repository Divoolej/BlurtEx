defmodule BlurtEx.ChatController do
  use BlurtEx.Web, :controller
  alias BlurtEx.User

  def index(conn, _params) do
    users = Repo.all from(u in User, where: not is_nil(u.message))
    render(conn, "index.html", users: users)
  end
end
