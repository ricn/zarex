defmodule Zarex do
  def sanitize(name, padding \\ 0) do
    result = String.strip(name)
    |> String.replace(~r/[[:space:]]+/u, " ") #normalize
    |> String.slice(0, 255 - padding) #padding
    |> String.replace(~r/[\x00-\x1F\/\\:\*\?\"<>\|]/u, "") #sanitize
    |> fallback_filename
  end

  defp fallback_filename(str) do
    case String.length(str) do
      0 -> "file"
      _ -> str
    end
  end
end
