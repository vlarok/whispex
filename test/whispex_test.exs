defmodule WhispexTest do
  use ExUnit.Case
  doctest Whispex

  import Whispex
  use Whispex.Options

  @fixture Path.join(__DIR__, "fixtures/raivo.mp4")

  setup do
    on_exit(fn ->
      File.rm(@output_path)
    end)
  end

  test "set bitrate runs successfully" do
    command =
      Whispex.new_command()
      |> add_input_file(@fixture)
      |> add_file_option(option_language("English"))
      |> add_file_option(option_output_dir("other_dir"))
      |> add_file_option(option_output_format("vtt"))
      |> add_file_option(option_model("tiny"))

    assert {:ok,
            "[00:00.000 --> 00:05.400]  shouldn't cover your old well before you dig the new one.\n"} =
             execute(command)
  end
end
