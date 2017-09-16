defmodule BlurtEx.AuthHelper do
  alias BlurtEx.User

  def current_user(conn), do: Guardian.Plug.current_resource(conn)
  def logged_in?(conn), do: Guardian.Plug.authenticated?(conn)

  def current_user?(conn, user) do
    user == current_user(conn)
  end

  def current_user_or_admin?(conn, user) do
    current_user?(conn, user) || User.is_admin?(current_user(conn))
  end
end
