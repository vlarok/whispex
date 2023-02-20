defmodule Whispex.Command do
  @moduledoc false

  alias Whispex.File
  alias Whispex.Option

  @type files :: [File.t()]
  @type global_options :: [Option.t()]

  @type t :: %__MODULE__{
          files: files,
          global_options: global_options
        }

  defstruct files: [],
            global_options: []
end
