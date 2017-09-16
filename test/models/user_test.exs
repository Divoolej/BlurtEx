defmodule BlurtEx.UserTest do
  use BlurtEx.ModelCase

  alias BlurtEx.User

  @valid_attrs %{encrypted_password: "some encrypted_password", username: "some username"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
