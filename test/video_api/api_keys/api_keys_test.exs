defmodule VideoApi.ApiKeysTest do
  use VideoApi.DataCase

  alias VideoApi.ApiKeys

  describe "api_keys" do
    alias VideoApi.ApiKeys.ApiKey

    @valid_attrs %{api_key: "some api_key"}
    @update_attrs %{api_key: "some updated api_key"}
    @invalid_attrs %{api_key: nil}

    def api_key_fixture(attrs \\ %{}) do
      {:ok, api_key} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ApiKeys.create_api_key()

      api_key
    end

    test "list_api_keys/0 returns all api_keys" do
      api_key = api_key_fixture()
      assert ApiKeys.list_api_keys() == [api_key]
    end

    test "get_api_key!/1 returns the api_key with given id" do
      api_key = api_key_fixture()
      assert ApiKeys.get_api_key!(api_key.id) == api_key
    end

    test "create_api_key/1 with valid data creates a api_key" do
      assert {:ok, %ApiKey{} = api_key} = ApiKeys.create_api_key(@valid_attrs)
      assert api_key.api_key == "some api_key"
    end

    test "create_api_key/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ApiKeys.create_api_key(@invalid_attrs)
    end

    test "update_api_key/2 with valid data updates the api_key" do
      api_key = api_key_fixture()
      assert {:ok, %ApiKey{} = api_key} = ApiKeys.update_api_key(api_key, @update_attrs)
      assert api_key.api_key == "some updated api_key"
    end

    test "update_api_key/2 with invalid data returns error changeset" do
      api_key = api_key_fixture()
      assert {:error, %Ecto.Changeset{}} = ApiKeys.update_api_key(api_key, @invalid_attrs)
      assert api_key == ApiKeys.get_api_key!(api_key.id)
    end

    test "delete_api_key/1 deletes the api_key" do
      api_key = api_key_fixture()
      assert {:ok, %ApiKey{}} = ApiKeys.delete_api_key(api_key)
      assert_raise Ecto.NoResultsError, fn -> ApiKeys.get_api_key!(api_key.id) end
    end

    test "change_api_key/1 returns a api_key changeset" do
      api_key = api_key_fixture()
      assert %Ecto.Changeset{} = ApiKeys.change_api_key(api_key)
    end
  end
end
