defmodule TryalProjek.Repo.Migrations.CreateHomes do
  use Ecto.Migration

  def change do
    create table(:homes) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
