Zarex
=====

[![Build Status](https://travis-ci.org/ricn/zarex.png?branch=master)](https://travis-ci.org/ricn/zarex)
[![Hex.pm](https://img.shields.io/hexpm/v/zarex.svg)](https://hex.pm/packages/zarex)
[![Inline docs](http://inch-ci.org/github/ricn/zarex.svg?branch=master)](http://inch-ci.org/github/ricn/zarex)

Filename sanitization for Elixir. This is useful when you generate filenames for downloads from user input. The library is heavily inspired by
[Zaru](https://github.com/madrobby/zaru) which does the same thing but in Ruby.

```elixir
Zarex.sanitize("  what\ēver//wëird:user:înput:")
# => "whatēverwëirduserînput"
```

Zarex takes a given filename and normalizes, filters and truncates it.

It deletes the bad stuff but leaves unicode characters in place, so users can use whatever alphabets they want to. Zarex also doesn't remove whitespace—instead, any sequence of whitespace that is 1 or more characters in length is collapsed to a single space. Filenames are truncated so that they are at maximum 255 characters long.
