defmodule Whispex.Options.Main do
  @moduledoc """
  """
  alias Whispex.Option

  @known_options %{
    language: %Option{name: "--language", require_arg: true}
  }

  require Whispex.Options.Helpers
  Whispex.Options.Helpers.option_functions(@known_options)
end
