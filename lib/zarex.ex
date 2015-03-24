defmodule Zarex do
  def sanitize(name, padding \\ 0) do
    String.strip(name)
    |> String.replace(~r/[[:space:]]+/u, " ") #normalize
    |> String.slice(0, 255 - padding) #padding
    |> String.replace(~r/[\x00-\x1F\/\\:\*\?\"<>\|]/u, "") #sanitize
    |> fallback_filename
    |> filter_windows_reserved_names
    |> filter_dots
  end

  defp fallback_filename(str) do
    case String.length(str) do
      0 -> "file"
      _ -> str
    end
  end

  defp filter_windows_reserved_names(str) do
    wrn = ~w(CON PRN AUX NUL COM1 COM2 COM3 COM4 COM5 COM6 COM7 COM8 COM9 LPT1
    LPT2 LPT3 LPT4 LPT5 LPT6 LPT7 LPT8 LPT9)
    case Enum.member?(wrn, String.upcase(str)) do
      true  -> "file"
      false -> str
    end
  end

  defp filter_dots(str) do
    case String.starts_with?(str, ".") do
      true  -> "file#{str}"
      false -> str
    end
  end
end
