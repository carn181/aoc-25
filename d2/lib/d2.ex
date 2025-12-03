defmodule D2 do
  @moduledoc """
  Documentation for `D2`.
  """

  @doc """
  Approach 1: 
  Brute force all numbers in range, check if current combination is a repetition.

  Approach 2:
  Generate possible invalid ids in range.
  n <- ldigit
  m <- rdigit

  Assume n=m

  By definition, if len of number not even, always valid
  if len even => Try combinations odd

  Problem: Hard to come up with a consistent algo for this.

  Let's go with bruteforce
  """
  def solve1 do
    "input.txt"
    |> File.read!()
    |> String.split()
    |> hd
    |> String.split(",")
    |> Enum.map(fn x -> String.split(x, "-") end)
    |> find_invalid(&twice/1)
  end

  def solve2 do
    "input.txt"
    |> File.read!()
    |> String.split()
    |> hd
    |> String.split(",")
    |> Enum.map(fn x -> String.split(x, "-") end)
    |> find_invalid(&atleasttwice/1)
  end

  def find_invalid(ranges, invalid_checker) do
    Enum.reduce(
      ranges,
      0,
      fn range, sum ->
        [left, right] = Enum.map(range, &String.to_integer/1)

        curr =
          Enum.reduce(left..right, 0, fn i, total ->
            str = Integer.to_string(i)

            if invalid_checker.(str) do
              total + i
            else
              total
            end
          end)

        sum + curr
      end
    )
  end

  defp twice(str) do
    n = String.length(str)
    rem(n,2) == 0 && String.slice(str, 0, div(n, 2)) == String.slice(str, div(n, 2), n)
  end

  def all_equal?(list) do
    case list do
      [] -> true
      [head | tail] -> Enum.all?(tail, fn x -> x == head end)
    end
  end

  def splitk(str, k) do
    for <<char_group::binary-size(k) <- str>>, do: char_group
  end

  def factors(1) do
    []
  end
  def factors(n) when n > 1 do
    # Iterate from 1 up to n and check for divisibility
    1..n-1
    |> Enum.filter(fn i -> rem(n, i) == 0 end)
  end
  
  def atleasttwice(str) do
    str
    |> String.length()
    |> factors()
    |> Enum.reduce(
      false,
      fn k, prev ->
        all_equal?(splitk(str, k)) || prev
      end
    )
  end
end
