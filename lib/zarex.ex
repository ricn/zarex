defmodule Zarex do
  @moduledoc """
  Filename sanitization for Elixir. This is useful when you generate filenames for downloads from user input.

  Zarex takes a given filename and normalizes, filters and truncates it.

  It deletes the bad stuff but leaves unicode characters in place, so users can
  use whatever alphabets they want to. Zarex also doesn't remove whitespace—instead,
  any sequence of whitespace that is 1 or more characters in length is collapsed to a
  single space. Filenames are truncated so that they are at maximum 255 characters long.

  ### Examples

      iex> Zarex.sanitize("  what\ēver//wëird:user:înput:")
      "whatēverwëirduserînput"

      iex> Zarex.sanitize("<", filename_fallback: "file")
      "file"

  """

  @type options :: {:padding, pos_integer()} | {:filename_fallback, String.t()}
  @spec sanitize(String.t(), [options]) :: String.t()
  @doc """
    Takes a given filename and normalizes, filters and truncates it.

    If extra breathing room is required (for example to add your own filename
    extension later), you can leave extra room with the padding parameter
  """
  def sanitize(name, options \\ []) when is_binary(name) and is_list(options) do
    padding = Keyword.get(options, :padding, 0)
    filename_fallback = Keyword.get(options, :filename_fallback, "file")

    String.trim(name)
    |> String.replace(~r/[[:space:]]+/u, " ")
    |> String.slice(0, 255 - padding)
    |> String.replace(~r/[\x00-\x1F\/\\:\*\?\"<>\|]/u, "")
    |> String.replace(~r/[[:space:]]+/u, " ")
    |> filter_windows_reserved_names(filename_fallback)
    |> filter_dots(filename_fallback)
    |> filename_fallback(filename_fallback)
  end

  defp filename_fallback(name, fallback) do
    if String.length(name) == 0, do: fallback, else: name
  end

  defp filter_windows_reserved_names(name, fallback) do
    wrn = ~w(CON PRN AUX NUL COM1 COM2 COM3 COM4 COM5 COM6 COM7 COM8 COM9 LPT1
    LPT2 LPT3 LPT4 LPT5 LPT6 LPT7 LPT8 LPT9)
    if Enum.member?(wrn, String.upcase(name)), do: fallback, else: name
  end

  defp filter_dots(name, fallback) do
    if String.starts_with?(name, "."), do: "#{fallback}#{name}", else: name
  end
end
