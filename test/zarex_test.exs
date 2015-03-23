defmodule ZarexTest do
  use ExUnit.Case

  test "normalization" do
    Enum.each(["a", " a", "a ", " a ", "a    \n"],
    fn(name) -> assert Zarex.sanitize(name) == "a" end)

    Enum.each(["x x", "x  x", "x   x", "x\tx", "x\r\nx"],
    fn(name) -> assert Zarex.sanitize(name) == "x x" end)
  end

  test "truncation" do
    name = String.duplicate("A", 400)
    assert String.length(Zarex.sanitize(name)) == 255
    assert String.length(Zarex.sanitize(name, 10)) == 245
  end
end
