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

  test "sanitization" do
    assert "abcdef" == Zarex.sanitize("abcdef")
    assert "笊, ざる.pdf" == Zarex.sanitize("笊, ざる.pdf")
    assert "whatēverwëirduserînput" == Zarex.sanitize("  what\\ēver//wëird:user:înput:")
    Enum.each(["<", ">", "|", "/", "\\", "*", "?", ":"], fn(char) ->
      assert "file" == Zarex.sanitize(char)
      assert "a" == Zarex.sanitize("a#{char}")
      assert "a" == Zarex.sanitize("#{char}a")
      assert "aa" == Zarex.sanitize("a#{char}a")
    end)
  end

  test "windows reserved names" do
    assert "file" == Zarex.sanitize("CON")
    assert "file" == Zarex.sanitize("lpt1 ")
    assert "file" == Zarex.sanitize("com4")
    assert "file" == Zarex.sanitize(" aux")
    assert "file" == Zarex.sanitize(" LpT\x122")
    assert "COM10" == Zarex.sanitize("COM10")
  end

  test "blanks" do
    assert "file" == Zarex.sanitize("<")
  end

  test "dots" do
    assert "file.pdf" == Zarex.sanitize(".pdf")
    assert "file.pdf" == Zarex.sanitize("<.pdf")
    assert "file..pdf" == Zarex.sanitize("..pdf")
  end
end
