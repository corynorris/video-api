defmodule VideoApiWeb.TranscodingControllerTest do
  use VideoApiWeb.ConnCase

  alias VideoApi.Transcodings

  @create_attrs %{video_1080p: "some video_1080p", video_360p: "some video_360p", video_420p: "some video_420p", video_720p: "some video_720p"}
  @update_attrs %{video_1080p: "some updated video_1080p", video_360p: "some updated video_360p", video_420p: "some updated video_420p", video_720p: "some updated video_720p"}
  @invalid_attrs %{video_1080p: nil, video_360p: nil, video_420p: nil, video_720p: nil}

  def fixture(:transcoding) do
    {:ok, transcoding} = Transcodings.create_transcoding(@create_attrs)
    transcoding
  end

  describe "index" do
    test "lists all transcodings", %{conn: conn} do
      conn = get(conn, Routes.transcoding_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Transcodings"
    end
  end

  describe "new transcoding" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.transcoding_path(conn, :new))
      assert html_response(conn, 200) =~ "New Transcoding"
    end
  end

  describe "create transcoding" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transcoding_path(conn, :create), transcoding: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.transcoding_path(conn, :show, id)

      conn = get(conn, Routes.transcoding_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Transcoding"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transcoding_path(conn, :create), transcoding: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Transcoding"
    end
  end

  describe "edit transcoding" do
    setup [:create_transcoding]

    test "renders form for editing chosen transcoding", %{conn: conn, transcoding: transcoding} do
      conn = get(conn, Routes.transcoding_path(conn, :edit, transcoding))
      assert html_response(conn, 200) =~ "Edit Transcoding"
    end
  end

  describe "update transcoding" do
    setup [:create_transcoding]

    test "redirects when data is valid", %{conn: conn, transcoding: transcoding} do
      conn = put(conn, Routes.transcoding_path(conn, :update, transcoding), transcoding: @update_attrs)
      assert redirected_to(conn) == Routes.transcoding_path(conn, :show, transcoding)

      conn = get(conn, Routes.transcoding_path(conn, :show, transcoding))
      assert html_response(conn, 200) =~ "some updated video_1080p"
    end

    test "renders errors when data is invalid", %{conn: conn, transcoding: transcoding} do
      conn = put(conn, Routes.transcoding_path(conn, :update, transcoding), transcoding: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Transcoding"
    end
  end

  describe "delete transcoding" do
    setup [:create_transcoding]

    test "deletes chosen transcoding", %{conn: conn, transcoding: transcoding} do
      conn = delete(conn, Routes.transcoding_path(conn, :delete, transcoding))
      assert redirected_to(conn) == Routes.transcoding_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.transcoding_path(conn, :show, transcoding))
      end
    end
  end

  defp create_transcoding(_) do
    transcoding = fixture(:transcoding)
    {:ok, transcoding: transcoding}
  end
end
