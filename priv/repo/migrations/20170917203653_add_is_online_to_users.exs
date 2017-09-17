defmodule BlurtEx.Repo.Migrations.AddIsOnlineToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_online, :boolean, default: false, null: false
    end
  end
end
