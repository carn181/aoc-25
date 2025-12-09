defmodule D8 do
  @doc """
  """
  def solve1 do
    "input.txt"
    |> File.read!()
    |> String.split()
    |> Enum.map(fn x -> String.split(x, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple() end)
    |> distances()
  end
  def solve2 do
    "input.txt"
    |> File.read!()
    |> String.split()
    |> Enum.map(fn x -> String.split(x, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple() end)
    |> distances2()
  end

  def distances(coords) do
    distance_pairs(coords)
    |> Enum.sort(fn {_,_,d1}, {_,_,d2} -> d1 < d2 end)
    |> circuits(to_dsu_parents(coords), 0)
    |> dsu_sets()
    |> Enum.sort(fn {_, x}, {_, y} -> length(x) > length(y) end)
    |> Enum.map(fn {_, x} -> length(x) end)
    |> Enum.take(3)
    |> Enum.product
  end

  def distances2(coords) do
    distance_pairs(coords)
    |> Enum.sort(fn {_,_,d1}, {_,_,d2} -> d1 < d2 end)
    |> circuits2(to_dsu_parents(coords))
  end

  def distance_pairs(list) do
    i_coords = Enum.with_index(list)
    for {{x1, y1, z1}, i1} <- i_coords, {{x2, y2, z2}, i2} <- i_coords, i1 < i2 do
      {{x1, y1, z1}, {x2, y2, z2} , dist(x1,x2)+dist(y1,y2)+dist(z1,z2)}
    end
  end

  def to_dsu_parents(lst) do
    Map.new(lst, fn x -> {x, x} end)
  end

  def dsu_find(parents, x) do
    if parents[x] != x do
      dsu_find(parents, parents[x])
    else
      x
    end
  end
  
  def dsu_union(parents, x, y) do
    if !dsu_same_set(parents, x, y) do
      Map.put(parents, dsu_find(parents, x), dsu_find(parents, y))
    else
      parents
    end
  end

  def dsu_same_set(parents, x, y) do
    dsu_find(parents, x) == dsu_find(parents, y)
  end

  def dsu_sets(parents) do
    Enum.group_by(Map.keys(parents), fn x -> dsu_find(parents, x) end, fn x -> x end)
  end
  
  def circuits2(edges, parents) do
    initial_count = Kernel.map_size(parents)
    circuits2_helper(edges, parents, initial_count)
  end

  def circuits2_helper([curr | rest], parents, components) do
    {p1, p2, _} = curr

    if dsu_same_set(parents, p1, p2) do
      circuits2_helper(rest, parents, components)
    else
      new_parents = dsu_union(parents, p1, p2)
      if components - 1 == 1 do
        {x1, _, _} = p1
        {x2, _, _} = p2
        x1*x2
      else
        circuits2_helper(rest, new_parents, components - 1)
      end
    end
  end

  def circuits(_, parents, 999) do
    parents
  end
  
  def circuits([curr | rest], parents, pairs) do
    {p1, p2, _} = curr
    circuits(rest, dsu_union(parents, p1, p2), pairs+1)
  end

  def dist(x, y) do
    (x-y)**2
  end
end
