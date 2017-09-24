Zarex
=====

[![Build Status](https://travis-ci.org/ricn/zarex.png?branch=master)](https://travis-ci.org/ricn/zarex)
[![Hex.pm](https://img.shields.io/hexpm/v/zarex.svg)](https://hex.pm/packages/zarex)
[![Inline docs](http://inch-ci.org/github/ricn/zarex.svg?branch=master)](http://inch-ci.org/github/ricn/zarex)

Filename sanitization for Elixir. This is useful when you generate filenames for downloads from user input. The library is heavily inspired by
[Zaru](https://github.com/madrobby/zaru) which does the same thing but in Ruby.

## Installation

Add this to your `mix.exs` file, then run `mix do deps.get, deps.compile`:

```elixir
  {:zarex, "~> 0.4"}
```

## Examples

```elixir
Zarex.sanitize("  what\ēver//wëird:user:înput:")
# => "whatēverwëirduserînput"
```

Zarex takes a given filename and normalizes, filters and truncates it.

It deletes the bad stuff and leaves unicode characters in place, so users can use whatever alphabets they want to. Zarex doesn't remove whitespace—instead, any sequence of whitespace that is 1 or more characters in length is collapsed to a single space. Filenames are truncated so that they are at maximum 255 characters long.

If extra space is required (for example to add your own filename extension later), you can leave extra padding:

```elixir
Zarex.sanitize(String.duplicate("a", 400), padding: 10)
# returns a string with 245 chars. First the binary of 400 chars will be truncated
# to 255 chars and then the extra padding of 10 will truncate the binary to 245 chars.
```

## Credits

The following people have contributed ideas, documentation, or code to Zarex:

* Richard Nyström
* Thomas Fuchs (the creator of Zaru, the Ruby library Zarex is heavily based on)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
