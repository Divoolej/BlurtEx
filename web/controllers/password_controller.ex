defmodule BlurtEx.PasswordController do
  use BlurtEx.Web, :controller

  alias BlurtEx.Mailer
  alias BlurtEx.UserMailer
  alias BlurtEx.User

  def forgot(conn, _params) do
    render(conn, "forgot.html")
  end

  def recover(conn, %{ "email" => %{ "email" => email } }) do
    user = Repo.get_by(User, email: email)
    if user, do: UserMailer.reset_password(user) |> Mailer.deliver_later
    conn
    |> put_flash(:info, "Password recovery email sent.")
    |> redirect(to: session_path(conn, :new))
  end
end
