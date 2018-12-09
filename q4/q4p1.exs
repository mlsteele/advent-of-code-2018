defmodule X do
  defmodule Event do
    @enforce_keys [:time, :act, :id]
    defstruct @enforce_keys
  end

  def file_lines(path) do
    path |> File.stream! |> Stream.map(&String.trim/1) |> Enum.to_list
  end

  # Example line:
  #[1518-11-01 00:00] Guard #10 begins shift
  def parse_line(line) do
    [_, day, hm, evstr] = Regex.run(~r/\[(\d+-\d+-\d+) (\d+:\d+)\] (.*)/, line)
    time = "#{day}T#{hm}:00+00:00" |> parse_date!()
    gnma = Regex.run(~r/Guard #(\d+) begins shift/, evstr)
    {ev, id} = cond do
      evstr == "falls asleep" -> {:sleep, nil}
      evstr == "wakes up"     -> {:wake, nil}
      true -> {:start, gnma |> tl |> hd |> String.to_integer()}
    end
    %Event{time: time, act: ev, id: id}
  end

  def parse_date!(str) do
    case DateTime.from_iso8601(str) do
      {:ok, res, _} -> res
      {:error, err} -> throw(err)
    end
  end

  def main() do
    events = "./input.txt" |> X.file_lines
    |> Enum.map(&X.parse_line/1)
    |> IO.inspect

    guard_ids = (for ev <- events, ev.act == :start, into: MapSet.new, do: ev.id)
    |> IO.inspect(charlists: :as_lists)
  end
end

X.main
