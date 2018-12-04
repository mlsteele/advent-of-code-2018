defmodule X do
  # How many characters are shared in the same place.
  def distance(a, b) do
    [a, b]
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip
    |> Enum.count(fn {a, b} -> a != b end)
  end

  def find_pair(strs) do
    (for a <- strs, b <- strs, do: {a, b})
    |> Enum.find(:fudge, fn {a, b} -> distance(a, b) == 1 end)
  end

  def common_letters(a, b) do
    [a, b]
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip
    |> Enum.filter(fn {a, b} -> a == b end)
    |> Enum.map(fn {a, _} -> a end)
    |> Enum.join()
  end

  def file_lines(path) do
    path |> File.stream! |> Stream.map(&String.trim/1) |> Enum.to_list
  end
end

"./input.txt" |> X.file_lines
|> X.find_pair
|> fn {a, b} -> X.common_letters(a, b) end.()
|> IO.inspect
