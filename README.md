# Whispex

An Elixir wrapper for the OpenAI/Whisper command line interface.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `whispex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:whispex, "~> 0.1.0"}
  ]
end
```

## Example

```elixir
import Whispex
use Whispex.Options

command =
  Whispex.new_command
  |> add_input_file("/path/to/input.mp4")
  |> add_file_option(option_language("English"))

{:ok, "[00:00.000 --> 00:05.000]  shouldn't cover your old well before you dig the new one.\n"} = execute(command)
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/whispex>.

