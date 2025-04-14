defmodule GistCloneWeb.Utils.DateFormat do
  def format_date(date, format \\ "{0D}/{0M}/{YYYY} {0h24}:{0m}") do
    date
    |> Timex.Timezone.convert("America/Bahia")
    |> Timex.format!(format)
  end
end
