defmodule BlurtEx.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2]

  defp login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user, :access)
  end

  def login_with(conn, email, password, options) do
    repo = Keyword.fetch!(options, :repo)
    user = repo.get_by(BlurtEx.User, email: email)
    cond do
        user && checkpw(password, user.encrypted_password) ->
          { :ok, login(conn, user) }
        user ->
          { :error, :unauthorized, conn }
        true ->
          { :error, :not_found, conn }
     end
  end
end
