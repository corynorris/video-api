defmodule VideoApi.PropertiesTest do
  use VideoApi.DataCase

  alias VideoApi.Accounts
  alias VideoApi.Properties
  alias VideoApi.Properties.Property

  @valid_attrs %{description: "some description", title: "some title", url: "some url"}
  @update_attrs %{
    description: "some updated description",
    title: "some updated title",
    url: "some updated url"
  }
  @invalid_attrs %{description: nil, title: nil, url: nil}

  defp user_fixture do
    {:ok, user} =
      Accounts.create_user(%{
        first_name: "Test",
        last_name: "User",
        email: "properties-test@example.com",
        password: "secret123"
      })

    user
  end

  defp property_fixture(attrs \\ %{}) do
    {:ok, property} =
      attrs
      |> Enum.into(@valid_attrs)
      |> then(&Properties.create_property(user_fixture(), &1))

    property
  end

  test "list_properties/0 returns all properties" do
    property = property_fixture()
    assert Properties.list_properties() == [property]
  end

  test "get_property!/1 returns the property with given id" do
    property = property_fixture()
    assert Properties.get_property!(property.id) == property
  end

  test "create_property/2 with valid data creates a property" do
    assert {:ok, %Property{} = property} =
             Properties.create_property(user_fixture(), @valid_attrs)

    assert property.description == "some description"
    assert property.title == "some title"
    assert property.url == "some url"
  end

  test "create_property/2 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} =
             Properties.create_property(user_fixture(), @invalid_attrs)
  end

  test "update_property/2 with valid data updates the property" do
    property = property_fixture()
    assert {:ok, %Property{} = property} = Properties.update_property(property, @update_attrs)
    assert property.description == "some updated description"
    assert property.title == "some updated title"
    assert property.url == "some updated url"
  end

  test "update_property/2 with invalid data returns error changeset" do
    property = property_fixture()
    assert {:error, %Ecto.Changeset{}} = Properties.update_property(property, @invalid_attrs)
    assert property == Properties.get_property!(property.id)
  end

  test "delete_property/1 deletes the property" do
    property = property_fixture()
    assert {:ok, %Property{}} = Properties.delete_property(property)
    assert_raise Ecto.NoResultsError, fn -> Properties.get_property!(property.id) end
  end

  test "change_property/1 returns a property changeset" do
    property = property_fixture()
    assert %Ecto.Changeset{} = Properties.change_property(property)
  end
end
