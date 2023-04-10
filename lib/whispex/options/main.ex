defmodule Whispex.Options.Main do
  @moduledoc """
  """
  alias Whispex.Option

  @known_options %{
    language: %Option{name: "--language", require_arg: true},
    model: %Option{name: "--model", require_arg: true},
    output_dir: %Option{name: "--output_dir", require_arg: true},
    output_format: %Option{name: "--output_format", require_arg: true}
  }

  require Whispex.Options.Helpers
  Whispex.Options.Helpers.option_functions(@known_options)
end
