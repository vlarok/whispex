defmodule Whispex.Options do
  @moduledoc """
  Convenience to import all Whispex options.

  ```
  use Whispex.Options
  ```
  """

  defmacro __using__(_) do
    quote do
      import Whispex.Options.Main
    end
  end
end
