defmodule TryalProjek.HomepageTest do
  use TryalProjek.DataCase

  alias TryalProjek.Homepage

  describe "homes" do
    alias TryalProjek.Homepage.Home

    import TryalProjek.HomepageFixtures

    @invalid_attrs %{name: nil}

    test "list_homes/0 returns all homes" do
      home = home_fixture()
      assert Homepage.list_homes() == [home]
    end

    test "get_home!/1 returns the home with given id" do
      home = home_fixture()
      assert Homepage.get_home!(home.id) == home
    end

    test "create_home/1 with valid data creates a home" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Home{} = home} = Homepage.create_home(valid_attrs)
      assert home.name == "some name"
    end

    test "create_home/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Homepage.create_home(@invalid_attrs)
    end

    test "update_home/2 with valid data updates the home" do
      home = home_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Home{} = home} = Homepage.update_home(home, update_attrs)
      assert home.name == "some updated name"
    end

    test "update_home/2 with invalid data returns error changeset" do
      home = home_fixture()
      assert {:error, %Ecto.Changeset{}} = Homepage.update_home(home, @invalid_attrs)
      assert home == Homepage.get_home!(home.id)
    end

    test "delete_home/1 deletes the home" do
      home = home_fixture()
      assert {:ok, %Home{}} = Homepage.delete_home(home)
      assert_raise Ecto.NoResultsError, fn -> Homepage.get_home!(home.id) end
    end

    test "change_home/1 returns a home changeset" do
      home = home_fixture()
      assert %Ecto.Changeset{} = Homepage.change_home(home)
    end
  end
end
