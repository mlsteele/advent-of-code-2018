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
    vals = Regex.run(~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/, line)
    |> tl
    |> Enum.map(&String.to_integer/1)
    keys = [:id, :x, :y, :w, :h]
    struct(Patch, Enum.zip(keys, vals) |> Enum.into(%{}))
  end

  # Find the canvas size {w, h} which is the maximum
  # for x and y axes of (patch.x + patch.w).
  def canvas_size(patches) do
    cx = patches |> Enum.map(&(&1.x + &1.w)) |> Enum.max
    cy = patches |> Enum.map(&(&1.y + &1.h)) |> Enum.max
    {cx, cy}
  end

  def create_canvas({_w, _h}) do
    %{}
  end

  # Increment the value in a cell of the canvas.
  def paint_cell({x, y}, canvas) do
    Map.update(canvas, {x, y}, 1, &(1+&1))
  end

  def paint_patch(patch, canvas) do
    xrange = patch.x..(patch.x + patch.w - 1)
    yrange = patch.y..(patch.y + patch.h - 1)
    (for x <- xrange, y <- yrange, do: {x,y})
    |> Enum.reduce(canvas, &X.paint_cell/2)
  end

  def count_overlap(canvas) do
    canvas |> Map.values |> Enum.filter(&(&1 > 1)) |> Enum.count
  end

  def main() do
    patches = "./input.txt" |> X.file_lines
    |> Enum.map(&X.parse_line/1)
    canvas = patches |> X.canvas_size |> X.create_canvas
    patches
    |> Enum.reduce(canvas, &X.paint_patch/2)
    |> IO.inspect
    |> X.count_overlap
    |> IO.inspect
  end
end

X.main
