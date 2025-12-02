defmodule Utils do
  def read_puzzle_input(path) do
    path
    |> File.read!()
  end

  def read_puzzle_input_with_split(path, delimiter) do
    path
    |> File.read!()
    |> String.split(delimiter, trim: true)
  end
end
