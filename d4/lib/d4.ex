defmodule D4 do
  @moduledoc """
  Todo: Return number of rolls that have < 4 in surrounding 8 positions

  Given is 2D Graph of the map
  Idea: Go through all the squares, see surrounding of that square and add to total if it's less than 4

  O(nm*8)
  Any optimizations ? 
  DP ?
  Greedy ?
  Any DS we could use ?

  Let's look at formalized solution.
  Let f(i,j) => No of adjacent towels
  Let g(i,j) => {0 | f(i,j) >= 4, 1 | f(i,j) < 4}
  Answer => Sum_{i=0}^{n} Sum_{j=0}^{m} g(i,j)

  Should we implement bruteforce first and then see if part 2 forces us to optimize ?
  Let's implement
  """

  def solve1 do
    "input.txt"
    |> process_map
    |> countpossibleremoves()
  end
  
  def solve2 do
    "input.txt"
    |> process_map
    |> counttotalremoves()
  end

  def process_map(file) do
    file
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.graphemes/1)
  end

  def at(enum, i, j) do
    Enum.at(Enum.at(enum, i), j)
  end

  def countpossibleremoves(rolls) do
    n = length(rolls)
    m = length(hd(rolls))
    {graph, _ } = to_graph(rolls, MapSet.new(), 0, 0, n, m)
    graph
    |> Map.values()
    |> Enum.map(&length/1)
    |> Enum.filter(fn x -> x < 4 end)
    |> length
  end

  def counttotalremoves(rolls) do
    n = length(rolls)
    m = length(hd(rolls))
    {graph, _ } = to_graph(rolls, MapSet.new(), 0, 0, n, m)
    to_remove = graph
    |> Enum.filter(fn {_, val} -> length(val) < 4 end)
    |> Enum.map(fn {key, _} -> key end)
    if length(to_remove) > 0 do 
      length(to_remove) + counttotalremoves(removerolls(to_remove, rolls))
    else
      0
    end
  end

  def update_at(list, row, col, new) do
    List.update_at(list, row, fn row -> List.update_at(row, col, fn _ -> new end) end)
  end

  def removerolls(rolls, map) do
    Enum.reduce(rolls, map, fn {row, col}, map -> update_at(map, row, col, ".") end) 
  end

  def valid(i, j, n, m) do
    i >= 0 && i < n && j >= 0 && j < m
  end

  @doc """
  Transforms paper rolls to graph adjacency list
  """
  def to_graph(rolls, visited, i, j, n, m) do
    if !valid(i, j, n, m) or MapSet.member?(visited, {i, j}) do
      {%{}, visited}
    else if valid(i, j, n, m) && !MapSet.member?(visited, {i,j}) do
        new_visited = MapSet.put(visited, {i,j})
        new_g = if at(rolls, i, j) == "@", do: %{{i,j} => []}, else: %{}
        [
          {i - 1, j - 1}, {i - 1, j}, {i - 1, j + 1},
          {i, j - 1},                 {i, j + 1},
          {i + 1, j - 1}, {i + 1, j}, {i + 1, j + 1}
        ]
        |> Enum.reduce({new_g, new_visited}, 
          fn {a, b}, {g, visited} -> 
            if valid(a,b, n, m) do
              if at(rolls, a, b) == "@" && at(rolls, i, j) == "@" do
                new_g = Map.put(g, {i,j}, Enum.concat([{a,b}], Map.get(g, {i,j}, [])))
                {child_g, new_visited} = to_graph(rolls, visited, a,b,n,m)
                {Map.merge(new_g, child_g), new_visited}
              else
                {child_g, new_visited} = to_graph(rolls, visited, a,b,n,m)
                {Map.merge(g, child_g), new_visited}
              end
            else
              {g, visited}
            end
        end)
      end
    end
  end
end
