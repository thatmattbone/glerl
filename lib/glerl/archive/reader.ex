defmodule Glerl.Archive.Reader do
  alias Glerl.Archive.DataDir

  @spec filename_for_date(Date.t()) :: Sring.t()
  def filename_for_date(date) do
    month = String.pad_leading("#{date.month}", 2, "0")
    day = String.pad_leading("#{date.day}", 2, "0")

    DataDir.create_data_dir() <> "/" <> "#{date.year}_#{month}_#{day}.json"
  end

  @spec data_for_date(Date.t()) :: list(Glerl.Datapoint.t())
  def data_for_date(date) do
    date
      |> filename_for_date()
      |> File.read!()
      |> Jason.decode!(keys: :atoms)
      |> Enum.map(&struct(Glerl.Core.Datapoint, &1))
  end

  # Glerl.Archive.Reader.data_for_date(~D[2023-04-11])
end
