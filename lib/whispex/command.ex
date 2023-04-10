defmodule Whispex.Command do
  alias Whispex.File

  @type files :: [File.t()]

  @type t :: %__MODULE__{
          files: files
        }

  defstruct files: []
end
