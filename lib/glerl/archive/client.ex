defmodule Glerl.Archive.Client do

  def lt_or_eq(test_result) when test_result == :lt, do: true
  def lt_or_eq(test_result) when test_result == :eq, do: true
  def lt_or_eq(_test_result), do: false


  def gt_or_eq(test_result) when test_result == :gt, do: true
  def gt_or_eq(test_result) when test_result == :eq, do: true
  def gt_or_eq(_test_result), do: false


  def data_for_date(date, start_time, end_time) do
    start_datetime = DateTime.new!(date, start_time) |> DateTime.from_naive!("America/Chicago")
    end_datetime = DateTime.new!(date, end_time) |> DateTime.from_naive!("America/Chicago")

    IO.inspect(start_datetime)
    IO.inspect(end_datetime)

    Glerl.Archive.Reader.data_for_date(date) |>
      Enum.filter(fn datapoint ->
        start_test = gt_or_eq(DateTime.compare(datapoint.timestamp, start_datetime))
        end_test = lt_or_eq(DateTime.compare(datapoint.timestamp, end_datetime))

        start_test && end_test
      end)
  end


  def data_for_session(session, date) when session == :morning do
    data_for_date(date, ~T[07:30:00], ~T[13:00:00])
  end

  def data_for_session(session, date) when session == :afternoon do
    data_for_date(date, ~T[12:30:00], ~T[18:00:00])
  end

  def data_for_session(session, date) when session == :evening do
    data_for_date(date, ~T[17:30:00], ~T[23:00:00])
  end
end
