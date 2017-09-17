defmodule BlurtEx.Repo.Migrations.AddPositionAndMessageAndModifiedAtToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :message, :text
      add :position, :integer
      add :modified_at, :datetime
    end
  end
end
