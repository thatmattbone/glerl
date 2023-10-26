defmodule Glerl.Archive.DownloaderTest do
  use ExUnit.Case
  doctest Glerl.Archive.Downloader

  test "test filename from year" do
    assert Glerl.Archive.Downloader.filename_for_year(2010) == "chi2010.04t.txt"

    assert_raise FunctionClauseError, fn ->
      Glerl.Archive.Downloader.filename_for_year(1999)
    end
  end

  test "url for year" do
    assert Glerl.Archive.Downloader.url_for_year(2019) ==
             "https://www.glerl.noaa.gov/metdata/chi/archive/chi2019.04t.txt"
  end

  test "file path for year" do
    # TODO this test has side-effects. it creates the data dir in the local repo. should probably fix or isolate it somehow
    assert Glerl.Archive.Downloader.file_path_for_year(2012) == "data/chi2012.04t.txt"
  end
end
