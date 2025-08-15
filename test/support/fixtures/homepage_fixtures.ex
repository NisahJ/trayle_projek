defmodule TryalProjek.HomepageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TryalProjek.Homepage` context.
  """

  @doc """
  Generate a home.
  """
  def home_fixture(attrs \\ %{}) do
    {:ok, home} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> TryalProjek.Homepage.create_home()

    home
  end
end
