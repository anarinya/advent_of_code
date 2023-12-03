defmodule AoC.One do
  @data_dir "../../data/one/"
  @data_file "data.txt"
  @part1_ex "data_ex1.txt"
  @part2_ex "data_ex2.txt"

  @map %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  @spec setup() :: [String.t()]
  def setup do
    File.stream!(Path.join(@data_dir, @data_file))
    |> Stream.map(&String.trim/1)
    |> Stream.map(&split_digits_and_letters/1)
  end

  # part 1 solution
  @spec part_one() :: integer
  def part_one do
    setup()
    |> Stream.map(&parse_digits/1)
    |> Enum.sum()
  end

  # part 2 solution
  @spec part_two() :: integer
  def part_two do
    setup()
    |> Stream.map(&parse_number_strings/1)
    |> Stream.map(&parse_digits/1)
    |> Enum.sum()
  end

  # parse list of number strings
  @spec parse_number_strings([String.t()]) :: [String.t()]
  defp parse_number_strings(word_list), do: Enum.flat_map(word_list, &convert_words_to_numbers/1)

  # break out string into list of numbers
  defp convert_words_to_numbers(words) do
    case Integer.parse(words) do
      :error -> parse_words(words)
      _ -> String.graphemes(words)
    end
  end

  # return list of words converted into numbers
  defp parse_words(word) do
    for idx <- 0..(String.length(word) - 1),
        key <- Map.keys(@map),
        String.equivalent?(String.slice(word, idx..(idx + String.length(key) - 1)), key),
        into: [],
        do: @map[key]
  end

  # break out single digits, combine first and last digits
  @spec parse_digits(String.t()) :: integer
  defp parse_digits(line) do
    line
    |> Enum.filter(&String.match?(&1, ~r/-?\d/))
    |> Enum.flat_map(&String.split(&1, "", trim: true))
    |> get_number()
  end

  # split out digits and words
  @spec split_digits_and_letters(String.t()) :: [String.t()]
  defp split_digits_and_letters(line),
    do: String.split(line, ~r/(?<=\d{1})(?=[a-z])|(?<=[a-z])(?=\d{1})/)

  # take first and last available numbers, combine into integer
  @spec get_number([String.t()]) :: integer
  defp get_number([]), do: 0
  defp get_number([head]), do: String.to_integer("#{head}#{head}")
  defp get_number([head | tail]), do: String.to_integer("#{head}#{List.last(tail)}")
end
