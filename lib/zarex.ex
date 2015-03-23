defmodule Zarex do
  def sanitize(name, padding \\ 0) do
    String.strip(name)
    |> String.replace(~r/[[:space:]]+/u, " ")
    |> String.slice(0, 255 - padding)
  end
end
