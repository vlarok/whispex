defmodule Whispex.File do
  @moduledoc false

  alias Whispex.Option

  @type path :: binary
  @type options :: [Option.t()]
  @type type :: :input | :output

  @type t :: %__MODULE__{
          path: path,
          options: options,
          type: type
        }

  defstruct path: nil,
            options: [],
            type: nil

  def add_option(%__MODULE__{options: options} = file, %Option{} = option) do
    %__MODULE__{file | options: [option | options]}
  end

  def add_option(%__MODULE__{options: options} = file, option_name) when is_binary(option_name) do
    option = %Option{name: option_name}
    %__MODULE__{file | options: [option | options]}
  end

  def add_option(%__MODULE__{options: options} = file, %Option{} = option, argument) do
    option = %Option{option | argument: argument}
    %__MODULE__{file | options: [option | options]}
  end

  def add_option(%__MODULE__{options: options} = file, option_name, argument)
      when is_binary(option_name) do
    option = %Option{name: option_name, argument: argument}
    %__MODULE__{file | options: [option | options]}
  end

  def command_arguments(file, acc \\ [])
  def command_arguments(%__MODULE__{options: []}, acc), do: acc

  def command_arguments(%__MODULE__{options: [option | options]} = file, acc) do
    command_arguments(%__MODULE__{file | options: options}, acc ++ arg_for_option(option))
  end

  defp arg_for_option(%Option{name: name, require_arg: false, argument: nil}) do
    ~w(#{name})
  end

  defp arg_for_option(%Option{name: name, argument: arg}) when not is_nil(arg) do
    ~w(#{name} #{arg})
  end
end
