defmodule BlurtEx.SessionController do
  use BlurtEx.Web, :controller

  alias BlurtEx.Auth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{ "session" => %{ "email" => email, "password" => password } }) do
    case Auth.login_with(conn, email, password, repo: Repo) do
      { :ok, conn } ->
        conn
        |> put_flash(:info, "Logged in successfully.")
        |> redirect(to: chat_path(conn, :index))
      { :error, _reason, conn } ->
        conn
        |> put_flash(:error, "Wrong email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out
    |> redirect(to: "/")
  end
end
