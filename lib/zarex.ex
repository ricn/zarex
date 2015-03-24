defmodule Zarex do
  def sanitize(name, padding \\ 0) do
    String.strip(name)
    |> String.replace(~r/[[:space:]]+/u, " ") #normalize
    |> String.slice(0, 255 - padding) #padding
    |> String.replace(~r/[\x00-\x1F\/\\:\*\?\"<>\|]/u, "") #sanitize
    |> filter_windows_reserved_names
    |> filter_dots
    |> filename_fallback
  end

  defp filename_fallback(name) do
    if String.length(name) == 0, do: "file", else: name
  end

  defp filter_windows_reserved_names(name) do
    wrn = ~w(CON PRN AUX NUL COM1 COM2 COM3 COM4 COM5 COM6 COM7 COM8 COM9 LPT1
    LPT2 LPT3 LPT4 LPT5 LPT6 LPT7 LPT8 LPT9)
    if Enum.member?(wrn, String.upcase(name)), do: "file", else: name
  end

  defp filter_dots(name) do
    if String.starts_with?(name, "."), do: "file#{name}", else: name
  end
end
