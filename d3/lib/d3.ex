defmodule D3 do
  @moduledoc """
  Naive implementation

  Optimization thoughts: Some kind of prefix sum of sub ranges to avoid having to repeat comparisons for max()
  """

  def solve1 do
    "input.txt"
    |> process_banks()
    |> totaljoltage(&maxjolt/1)
  end

  def solve2 do
    "input.txt"
    |> process_banks()
    |> totaljoltage(&maxjolt12/1)
  end

  def process_banks(file) do
    file
    |> File.read!()
    |> String.split()
  end

  def totaljoltage(banks, maxjoltfinder) do
    banks
    |> Task.async_stream(fn bank ->
      maxjoltfinder.(bank)
    end)
    |> Enum.reduce(0, fn {:ok, sum}, acc -> acc + sum end)
  end

  defp maxjolt(bank) do
    arr = String.graphemes(bank)
    dig1 = Enum.max(Enum.slice(arr, 0, length(arr) - 1))
    mid = Enum.find_index(arr, fn x -> x == dig1 end)
    dig2 = Enum.max(Enum.slice(arr, mid + 1, length(arr) - 1))
    String.to_integer(dig1 <> dig2)
  end

  def maxjolt12(bank) do
    String.to_integer(maxjolthelper(0, String.graphemes(bank)))
  end

  defp maxjolthelper(digits, remaining) do
    if digits == 12 do
      ""
    else
      dig1 = Enum.max(Enum.slice(remaining, 0, length(remaining) - (12 - digits - 1)))
      mid = Enum.find_index(remaining, fn x -> x == dig1 end)
      dig1 <> maxjolthelper(digits + 1, Enum.slice(remaining, mid + 1, length(remaining)))
    end
  end
end
