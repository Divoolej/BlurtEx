defmodule BlurtEx.User do
  use BlurtEx.Web, :model

  schema "users" do
    field :email, :string
    field :username, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :is_admin, :boolean, default: false
    field :is_online, :boolean, default: false
    field :message, :text
    field :modified_at, :datetime

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :username, :password])
    |> validate_required([:email, :username, :password])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  def reg_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:password], [])
    |> validate_length(:password, min: 5)
    |> hash_pw()
  end

  def hash_pw(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: p}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(p))
      _ ->
        changeset
    end
  end

  def is_admin?(user), do: user.is_admin == true
end
