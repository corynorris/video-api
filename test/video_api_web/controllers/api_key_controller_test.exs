defmodule VideoApiWeb.ApiKeyControllerTest do
  use VideoApiWeb.ConnCase

  alias VideoApi.ApiKeys

  @create_attrs %{api_key: "some api_key"}
  @update_attrs %{api_key: "some updated api_key"}
  @invalid_attrs %{api_key: nil}

  def fixture(:api_key) do
    {:ok, api_key} = ApiKeys.create_api_key(@create_attrs)
    api_key
  end

  describe "index" do
    test "lists all api_keys", %{conn: conn} do
      conn = get(conn, Routes.api_key_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Api keys"
    end
  end

  describe "new api_key" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.api_key_path(conn, :new))
      assert html_response(conn, 200) =~ "New Api key"
    end
  end

  describe "create api_key" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_key_path(conn, :create), api_key: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.api_key_path(conn, :show, id)

      conn = get(conn, Routes.api_key_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Api key"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_key_path(conn, :create), api_key: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Api key"
    end
  end

  describe "edit api_key" do
    setup [:create_api_key]

    test "renders form for editing chosen api_key", %{conn: conn, api_key: api_key} do
      conn = get(conn, Routes.api_key_path(conn, :edit, api_key))
      assert html_response(conn, 200) =~ "Edit Api key"
    end
  end

  describe "update api_key" do
    setup [:create_api_key]

    test "redirects when data is valid", %{conn: conn, api_key: api_key} do
      conn = put(conn, Routes.api_key_path(conn, :update, api_key), api_key: @update_attrs)
      assert redirected_to(conn) == Routes.api_key_path(conn, :show, api_key)

      conn = get(conn, Routes.api_key_path(conn, :show, api_key))
      assert html_response(conn, 200) =~ "some updated api_key"
    end

    test "renders errors when data is invalid", %{conn: conn, api_key: api_key} do
      conn = put(conn, Routes.api_key_path(conn, :update, api_key), api_key: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Api key"
    end
  end

  describe "delete api_key" do
    setup [:create_api_key]

    test "deletes chosen api_key", %{conn: conn, api_key: api_key} do
      conn = delete(conn, Routes.api_key_path(conn, :delete, api_key))
      assert redirected_to(conn) == Routes.api_key_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.api_key_path(conn, :show, api_key))
      end
    end
  end

  defp create_api_key(_) do
    api_key = fixture(:api_key)
    {:ok, api_key: api_key}
  end
end
