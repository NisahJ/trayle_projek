defmodule TryalProjek.Homepage.Home do
  use Ecto.Schema
  import Ecto.Changeset

  schema "homes" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(home, attrs) do
    home
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
