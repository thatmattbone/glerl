defmodule Glerl.Archive.DataDir do
  @doc """
  Return the location of the data directory for the data archive.
  """
  @spec get_data_dir() :: String.t()
  def get_data_dir() do
    "data"
  end

  @doc """
  Create the data directory for the data archive if it does not already exist.
  """
  @spec create_data_dir() :: String.t()
  def create_data_dir() do
    data_dir = get_data_dir()

    if not File.exists?(get_data_dir()) do
      File.mkdir!(data_dir)
    end

    data_dir
  end
end
