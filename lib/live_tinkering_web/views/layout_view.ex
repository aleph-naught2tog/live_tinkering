defmodule LiveTinkeringWeb.LayoutView do
  use LiveTinkeringWeb, :view

  @compile_timestamp [Date.utc_today(), Time.utc_now()]

  def last_compiled do
    [date, time] = @compile_timestamp
    micros = time.microsecond |> elem(0) |> to_string() |> String.split_at(2) |> elem(0)

    "#{pad(date.month)}/#{pad(date.day)}/#{date.year}" <>
      " at #{pad(time.hour)}:#{pad(time.minute)}:#{pad(time.second)}.#{micros}"
  end

  defp pad(number) do
    number
    |> to_string()
    |> String.pad_leading(2, "0")
  end
end
