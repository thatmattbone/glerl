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
      |> Enum.map(fn %{timestamp: timestamp_str}=data_point ->
          {:ok, timestamp, _} = DateTime.from_iso8601(timestamp_str)

          timestamp = timestamp
            |> DateTime.truncate(:second)
            |> DateTime.shift_zone!("America/Chicago")

          %{data_point | timestamp: timestamp}
        end)
  end

  # Glerl.Archive.Reader.data_for_date(~D[2023-04-11])
end
