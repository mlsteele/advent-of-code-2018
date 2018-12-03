defmodule X do
  # Input: "abca"
  # Output: %{"a" => 2, "b" => 1, "c" => 1}
  def char_occurrences(str) do
    str
    |> String.graphemes
    |> Enum.reduce(%{}, fn x, acc -> Map.update acc, x, 1, &(&1 + 1) end)
  end

  # Set of cardinality of each repeated character.
  # Input: "aaaabbc"
  # Output: #MapSet<[1, 2, 4]>
  def repeats(str) do
    str
    |> char_occurrences
    |> Map.values
    |> MapSet.new
  end

  def checksum(strs) do
    repeat_sets = strs |> Enum.map(&(repeats(&1)))
    twice = repeat_sets |> Enum.count(&(MapSet.member?(&1, 2)))
    thrice = repeat_sets |> Enum.count(&(MapSet.member?(&1, 3)))
    twice * thrice
  end

  def file_lines(path) do
    path |> File.stream! |> Stream.map(&String.trim/1) |> Enum.to_list
  end
end

"./input.txt" |> X.file_lines
|> X.checksum
|> IO.inspect
