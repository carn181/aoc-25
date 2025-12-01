defmodule D1 do
  @moduledoc """
  Documentation for `D1`.
  """

  @doc """
  Idea: Recursive function that takes in previous lock number state + current password => Can use reduce
  """
  def solve1 do
    "input.txt"
    |> File.read!
    |> String.split()
    |> Enum.map(&parse_move/1)
    |> process_moves(&count_final_zeros/2)
  end

  def solve2 do
    "input.txt"
    |> File.read!
    |> String.split()
    |> Enum.map(&parse_move/1)
    |> process_moves(&count_crossings/2)
  end
  
  defp process_moves(moves, counter_fn) do
    Enum.reduce(moves, {50, 0}, fn move, {position, count} ->
      new_position = rem(position + move, 100)
      new_count = count + counter_fn.(position, move)
      {new_position, new_count}
    end)
    |> elem(1)
  end

  def parse_move(<<"R", distance::binary>>), do: String.to_integer(distance)
  def parse_move(<<"L", distance::binary>>), do: -String.to_integer(distance)

  defp count_final_zeros(position, move) do
    new_position = rem(position + move, 100)
    if new_position == 0, do: 1, else: 0
  end
  
  defp count_crossings(position, move) do
    final_position = position + move
    abs(div(final_position, 100)) + 
      (if (final_position) == 0, do: 1, else: 0) + 
      (if (final_position)*position < 0, do: 1, else: 0)
  end
end
