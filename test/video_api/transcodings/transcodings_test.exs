defmodule VideoApi.TranscodingsTest do
  use VideoApi.DataCase

  alias VideoApi.Transcodings

  describe "transcodings" do
    alias VideoApi.Transcodings.Transcoding

    @valid_attrs %{video_1080p: "some video_1080p", video_360p: "some video_360p", video_420p: "some video_420p", video_720p: "some video_720p"}
    @update_attrs %{video_1080p: "some updated video_1080p", video_360p: "some updated video_360p", video_420p: "some updated video_420p", video_720p: "some updated video_720p"}
    @invalid_attrs %{video_1080p: nil, video_360p: nil, video_420p: nil, video_720p: nil}

    def transcoding_fixture(attrs \\ %{}) do
      {:ok, transcoding} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transcodings.create_transcoding()

      transcoding
    end

    test "list_transcodings/0 returns all transcodings" do
      transcoding = transcoding_fixture()
      assert Transcodings.list_transcodings() == [transcoding]
    end

    test "get_transcoding!/1 returns the transcoding with given id" do
      transcoding = transcoding_fixture()
      assert Transcodings.get_transcoding!(transcoding.id) == transcoding
    end

    test "create_transcoding/1 with valid data creates a transcoding" do
      assert {:ok, %Transcoding{} = transcoding} = Transcodings.create_transcoding(@valid_attrs)
      assert transcoding.video_1080p == "some video_1080p"
      assert transcoding.video_360p == "some video_360p"
      assert transcoding.video_420p == "some video_420p"
      assert transcoding.video_720p == "some video_720p"
    end

    test "create_transcoding/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transcodings.create_transcoding(@invalid_attrs)
    end

    test "update_transcoding/2 with valid data updates the transcoding" do
      transcoding = transcoding_fixture()
      assert {:ok, %Transcoding{} = transcoding} = Transcodings.update_transcoding(transcoding, @update_attrs)
      assert transcoding.video_1080p == "some updated video_1080p"
      assert transcoding.video_360p == "some updated video_360p"
      assert transcoding.video_420p == "some updated video_420p"
      assert transcoding.video_720p == "some updated video_720p"
    end

    test "update_transcoding/2 with invalid data returns error changeset" do
      transcoding = transcoding_fixture()
      assert {:error, %Ecto.Changeset{}} = Transcodings.update_transcoding(transcoding, @invalid_attrs)
      assert transcoding == Transcodings.get_transcoding!(transcoding.id)
    end

    test "delete_transcoding/1 deletes the transcoding" do
      transcoding = transcoding_fixture()
      assert {:ok, %Transcoding{}} = Transcodings.delete_transcoding(transcoding)
      assert_raise Ecto.NoResultsError, fn -> Transcodings.get_transcoding!(transcoding.id) end
    end

    test "change_transcoding/1 returns a transcoding changeset" do
      transcoding = transcoding_fixture()
      assert %Ecto.Changeset{} = Transcodings.change_transcoding(transcoding)
    end
  end
end
