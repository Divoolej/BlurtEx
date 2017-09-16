defmodule BlurtEx.UserController do
  use BlurtEx.Web, :controller

  alias BlurtEx.User

  def index(conn, _params) do
    users = Repo.all(User)
    cond do
      User.is_admin?(current_user(conn)) ->
        render(conn, "index.html", users: users)
      :unauthorized ->
        unauthorized(conn)
    end
  end

  def show(conn, %{ "id" => id }) do
    user = Repo.get!(User, id)
    cond do
      current_user_or_admin?(conn, user) ->
        render(conn, "show.html", user: user)
      :unauthorized ->
        unauthorized(conn)
    end
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{ "user" => user_params }) do
    changeset = User.reg_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      { :ok, _user } ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      { :error, changeset } ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{ "id" => id }) do
    user = Repo.get!(User, id)
    cond do
      current_user_or_admin?(conn, user) ->
        changeset = User.changeset(user)
        render(conn, "edit.html", user: user, changeset: changeset)
      :unauthorized ->
        unauthorized(conn)
    end
  end

  def update(conn, %{ "id" => id, "user" => user_params }) do
    user = Repo.get!(User, id)

    cond do
      current_user_or_admin?(conn, user) ->
        changeset = User.reg_changeset(user, user_params)
        case Repo.update(changeset) do
          { :ok, user } ->
            conn
            |> put_flash(:info, "User updated successfully.")
            |> redirect(to: user_path(conn, :show, user))
          { :error, changeset } ->
            render(conn, "edit.html", user: user, changeset: changeset)
        end
      :unauthorized ->
        unauthorized(conn)
    end
  end

  def delete(conn, %{ "id" => id }) do
    user = Repo.get!(User, id)

    cond do
      current_user_or_admin?(conn, user) ->
        Repo.delete!(user)
        conn
        |> Guardian.Plug.sign_out
        |> put_flash(:danger, "User deleted successfully.")
        |> redirect(to: session_path(conn, :new))
      :unauthorized ->
        unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_flash(:error, "You don't have access to that resource.")
    |> redirect(to: chat_path(conn, :index))
  end
end
