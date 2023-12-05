defmodule AoC.One do
  @data_dir "../../data/one/"
  @data_file "data.txt"
  @part1_ex "data_ex1.txt"
  @part2_ex "data_ex2.txt"

  @map %{
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9
  }

  def part_one do
    File.stream!(Path.join(@data_dir, @data_file))
    |> Stream.map(&String.to_charlist/1)
    |> Stream.map(&Enum.filter(&1, fn n -> n in ?0..?9 end))
    |> Stream.map(&[hd(&1), List.last(&1)])
    |> Stream.map(&List.to_integer/1)
    |> Enum.sum()
  end

  def part_two do
    regex = ~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/

    File.stream!(Path.join(@data_dir, @data_file))
    |> Stream.map(&Regex.scan(regex, &1, capture: :all_but_first))
    |> Stream.map(&List.flatten/1)
    |> Stream.map(&cast_numbers/1)
    |> Stream.map(&[hd(&1), List.last(&1)])
    |> Stream.map(&Integer.undigits/1)
    |> Enum.sum()
  end

  defp cast_numbers(list), do: Enum.map(list, &cast_item/1)

  defp cast_item(item) when is_map_key(@map, item), do: @map[item]
  defp cast_item(item), do: String.to_integer(item)
end
