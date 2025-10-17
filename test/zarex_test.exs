defmodule ZarexTest do
  use ExUnit.Case, async: true
  doctest Zarex

  test "normalization" do
    Enum.each(["a", " a", "a ", " a ", "a    \n"], fn name ->
      assert Zarex.sanitize(name) == "a"
    end)

    Enum.each(["x x", "x  x", "x   x", "x  |  x", "x\tx", "x\r\nx"], fn name ->
      assert Zarex.sanitize(name) == "x x"
    end)
  end

  test "truncation" do
    name = String.duplicate("A", 400)
    assert String.length(Zarex.sanitize(name)) == 255
    assert String.length(Zarex.sanitize(name, padding: 10)) == 245
  end

  test "truncation enforces byte limit" do
    name =
      "😄👏😄👏😄👏😄👏01😄👏😄👏😄👏😄👏02😄👏😄👏😄👏😄👏03😄👏😄👏😄👏😄👏04😄👏😄👏😄👏😄👏05😄👏😄👏😄👏😄👏06😄👏😄👏😄👏😄👏07😄👏😄👏😄👏😄👏08😄👏😄👏😄👏😄👏09😄👏😄👏😄👏😄👏10😄👏😄👏😄👏😄👏11😄👏😄👏😄👏😄👏12😄👏😄👏😄👏😄👏13😄👏😄👏😄👏😄👏14😄👏😄👏😄👏😄👏15😄👏😄👏😄👏😄👏16😄👏😄👏😄👏😄👏17😄👏😄👏😄👏😄👏18😄👏😄👏😄👏😄👏19😄👏😄👏😄👏😄👏20😄👏😄👏😄👏😄👏21😄👏😄👏😄👏😄👏22😄👏😄👏😄👏😄👏23😄👏😄👏😄👏😄👏24😄👏😄👏😄👏😄👏25"

    assert String.length(Zarex.sanitize(name)) == 74
    assert byte_size(Zarex.sanitize(name)) == 254
    assert String.length(Zarex.sanitize(name, padding: 10)) == 71
    assert byte_size(Zarex.sanitize(name, padding: 10)) == 242
  end

  test "sanitization" do
    assert "abcdef" == Zarex.sanitize("abcdef")
    assert "笊, ざる.pdf" == Zarex.sanitize("笊, ざる.pdf")
    assert "whatēverwëirduserînput" == Zarex.sanitize("  what\\ēver//wëird:user:înput:")

    Enum.each(["<", ">", "|", "/", "\\", "*", "?", ":"], fn char ->
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

  test "filename fallback" do
    assert "file" == Zarex.sanitize("")
    assert "document.pdf" == Zarex.sanitize("", filename_fallback: "document.pdf")
  end

  test "sanitize respects 255 byte limit even with leading dots" do
    # Create a string with 254 dots + "b" = 255 bytes (within limit)
    within_limit = String.duplicate(".", 254) <> "b"

    # Sanitize with fallback - should not exceed 255 bytes
    sanitized = Zarex.sanitize(within_limit, filename_fallback: "a")

    # The sanitized result should not exceed 255 bytes
    assert byte_size(sanitized) <= 255,
           "Expected byte size <= 255, got #{byte_size(sanitized)}"

    # Sanitizing the result again should produce the same result (idempotent)
    sanitized_again = Zarex.sanitize(sanitized, filename_fallback: "a")

    assert sanitized == sanitized_again,
           "Sanitize should be idempotent but got different results"
  end
end
