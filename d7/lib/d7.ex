defmodule D7 do
  @doc """
  """
  def solve1 do
    "input.txt"
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.graphemes/1)
    |> countbeamsinpath()
  end

  def solve2 do
    "input.txt"
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.graphemes/1)
    |> countpaths()
  end

  def at(arr, i, j) do
    Enum.at(Enum.at(arr, i), j)
  end

  def countbeamsinpath(map) do
    start = Enum.find_index(hd(map), &(&1 == "S"))
    {x, _} = beam(map, 0, start, MapSet.new())
    x
  end
  def countpaths(map) do
    start = Enum.find_index(hd(map), &(&1 == "S"))
    {_, visited} = beam(map, 0, start, MapSet.new())
    visited 
    |> Enum.filter(fn {i, _} -> i == length(map) -1 end) 
    |> Enum.map(
      fn {i,j} -> 
        {result, _} = paths(map, visited, i, j, %{}) 
      result end)
  end

  def paths(map, visited, i, j, cache) do
    cond do
      Map.has_key?(cache, {i, j}) ->
        {cache[{i, j}], cache}

      !valid(map, i, j) || !MapSet.member?(visited, {i, j}) -> 
        {0, cache}

      at(map, i, j) == "S" -> 
        {1, Map.put(cache, {i, j}, 1)}

      true ->
        {center, cache1} = paths(map, visited, i-1, j, cache)

        {left, cache2} = if valid(map, i-1, j-1) && 
          at(map, i-1, j-1) == "^" do
            paths(map, visited, i-1, j-1, cache1)
          else
            {0, cache1}
          end

        {right, cache3} = if valid(map, i-1, j+1) && 
          at(map, i-1, j+1) == "^" do
            paths(map, visited, i-1, j+1, cache2)
          else
            {0, cache2}
          end

        result = center + left + right
        {result, Map.put(cache3, {i, j}, result)}
    end
  end

  def valid(map, i, j) do
    0 <= i && i < length(map) && 0 <= j && j < length(hd(map)) 
  end

  def beampath(map, i, j, visited) do
    cond do
      MapSet.member?(visited, {i, j}) -> 
        0

      !valid(map, i, j) -> 
        1

      at(map, i, j) == "^" ->
        new_visited = MapSet.put(visited, {i, j})
        left = beampath(map, i+1, j-1, new_visited) 
        right = beampath(map, i+1, j+1, new_visited)
        left + right
      true ->
        new_visited = MapSet.put(visited, {i, j})
        beampath(map, i+1, j, new_visited)
    end
  end

  def beam(map, i, j, visited) do
    cond do
      !valid(map, i, j) || MapSet.member?(visited, {i, j}) -> 
        {0, visited}

      at(map, i, j) == "^" ->
        new_visited = MapSet.put(visited, {i, j})
        {left, visited1} = beam(map, i+1, j-1, new_visited) 
        {right, visited2} = beam(map, i+1, j+1, visited1)
        {1 + left + right, visited2}

      true ->
        new_visited = MapSet.put(visited, {i, j})
        beam(map, i+1, j, new_visited)
    end
  end
end
