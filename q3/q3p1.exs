defmodule X do
  defmodule Patch do
    @enforce_keys [:id, :x, :y, :w, :h]
    defstruct @enforce_keys
  end

  def file_lines(path) do
    path |> File.stream! |> Stream.map(&String.trim/1) |> Enum.to_list
  end

  #3 @ 5,5: 2x2
  def parse_line(line) do
    vals = Regex.run ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/, line
    |> IO.inspect
    crash()
    |> tl
    |> Enum.map(&String.to_integer/1)
    keys = [:id, :x, :y, :w, :h]
    struct(Patch, Enum.zip(vals, keys |> Enum.into(%{})))
  end

  # Find the canvas size {w, h} which is the maximum
  # for x and y axes of (patch.x + patch.w).
  def canvas_size(patches) do
    cx = patches |> Enum.map(&(&1.x + &1.w)) |> Enum.max
    cy = patches |> Enum.map(&(&1.y + &1.h)) |> Enum.max
    {cx, cy}
  end
end

"./input.txt" |> X.file_lines
|> Enum.map(&X.parse_line/1)
|> IO.inspect

"./input.txt" |> X.file_lines
|> Enum.map(&X.parse_line/1)
|> X.canvas_size
|> IO.inspect
