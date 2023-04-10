defmodule Whispex do
  @moduledoc """
  Create and execute whisper CLI commands.

  Note that adding options is backwards from using
  the whisper CLI; when using whisper CLI, you specify the options
  before each file.
  But with Whispex (this library), you add the file first, then
  add the relevant options afterward.

  ## Example

      import Whispex
      use Whispex.Options

      command =
        Whispex.new_command
        |> add_input_file("/path/to/input.avi")
        |> add_file_option(option_language("English"))
        |> add_file_option(option_output_dir("other_dir"))
        |> add_file_option(option_output_format("vtt"))
        |> add_file_option(option_model("tiny"))

      :ok = execute(command)
  """
  alias Whispex.Command
  alias Whispex.File

  @doc """
  Begin a new blank (no options) whisper command.
  """
  def new_command, do: %Command{}

  @doc """
  Add an input file to the command.
  """
  def add_input_file(%Command{files: files} = command, %File{} = file) do
    file = %File{file | type: :input}
    %Command{command | files: [file | files]}
  end

  def add_input_file(%Command{files: files} = command, file_path) when is_binary(file_path) do
    file = %File{type: :input, path: file_path}
    %Command{command | files: [file | files]}
  end

  @doc """
  Add an output file to the command.
  """
  def add_output_file(%Command{files: files} = command, %File{} = file) do
    file = %File{file | type: :output}
    %Command{command | files: [file | files]}
  end

  def add_output_file(%Command{files: files} = command, file_path) when is_binary(file_path) do
    file = %File{type: :output, path: file_path}
    %Command{command | files: [file | files]}
  end

  @doc """
  Add a per-file option to the command.

  Applies to the most recently added file.
  """
  def add_file_option(
        %Command{files: [file | files]} = command,
        option
      ) do
    file = %File{file | options: [option | file.options]}
    %Command{command | files: [file | files]}
  end

  @doc """
  Execute the command using whisper CLI.

  Returns `{:ok, output}` on success, or `{:error, {cmd_output, exit_status}}` on error.
  """
  @spec execute(command :: Command.t()) ::
          {:ok, binary()} | {:error, {Collectable.t(), exit_status :: non_neg_integer}}
  def execute(%Command{} = command) do
    {executable, args} = prepare(command)

    Rambo.run(executable, args, log: false)
    |> format_output()
  end

  @doc """
  Prepares the command to be executed, by converting the `%Command{}` into
  proper parameters to be feeded to `System.cmd/3` or `Port.open/2`.

  Under normal circumstances `Whispex.execute/1` should be used, use `prepare`
  only when converted args are needed to be feeded in a custom execution method.
  """
  @spec prepare(command :: Command.t()) :: {binary() | nil, list(binary)}
  def prepare(%Command{files: files}) do
    cmd_args = List.flatten([options_list(files)])
    {whisper_path(), cmd_args}
  end

  defp options_list(files) do
    input_files = Enum.filter(files, fn %File{type: type} -> type == :input end)
    output_files = Enum.filter(files, fn %File{type: type} -> type == :output end)
    options_list(input_files, output_files)
  end

  defp options_list(input_files, output_files, acc \\ [])
  defp options_list([], [], acc), do: List.flatten(acc)

  defp options_list(input_files, [output_file | output_files], acc) do
    acc = [File.command_arguments(output_file), output_file.path | acc]
    options_list(input_files, output_files, acc)
  end

  defp options_list([input_file | input_files], [], acc) do
    acc = [File.command_arguments(input_file), input_file.path | acc]
    options_list(input_files, [], acc)
  end

  defp format_output({:ok, %{out: stdout}}), do: {:ok, stdout}
  defp format_output({:error, reason}) when is_binary(reason), do: {:error, {reason, 1}}

  defp format_output({:error, %{err: stderr, status: exit_status}}),
    do: {:error, {stderr, exit_status}}

  # Read whisper path from config. If unspecified, assume `whisper` is in env $PATH.
  defp whisper_path do
    case Application.get_env(:whisper, :whisper_path, nil) do
      nil -> System.find_executable("whisper")
      path -> path
    end
  end
end
