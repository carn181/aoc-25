defmodule D5 do
  @doc """
  """
  def solve1 do
    "input.txt"
    |> process()
    |> countfresh()
  end 

  def solve2 do
    "input.txt"
    |> process()
    |> countpossiblefresh()
  end

  def countpossiblefresh([ranges, _]) do
    # If contain(range1, range2) -> new_range
    processranges(ranges)
    |> Enum.sort(fn ([l1,_],[l2,_]) -> l1 < l2 end)
    |> mergeall([])
    |> Enum.map(fn [l, r] -> if r == l, do: 1, else: r-l+1 end) |> Enum.sum()
  end

  # Compare with next element
  # If overlap -> merge and create new range 
  # else -> take next one as new compare
  def mergeall([], already) do
    already
  end

  def mergeall([first | remaining], []) do
    mergeall(remaining, [first])
  end

  def mergeall([curr | remaining], already) do
    last = List.last(already)
    before = List.delete_at(already, -1)
    if overlap?(curr, last) do
      mergeall(remaining, Enum.concat(before, [merge(curr, last)]))
    else
      mergeall(remaining, Enum.concat(already, [curr]))
    end
  end
  
  def merge([l1, r1], [l2, r2]) do
    [min(l1,l2), max(r1, r2)] 
  end

  def overlap?(r1, r2) do
    !disjoint?(r1, r2)
  end
  def disjoint?([l1, r1], [l2, r2]) do
    (l1 < l2 && r1 < r2 && r1 < l2) || (l2 < l1 && r2 < r1 && r2 < l1)
  end

  def process(file) do
    file
    |> File.read!()
    |> String.split("\n\n")
    |> Enum.map(&String.split/1)
  end

  def countfresh([ranges, ids]) do
    validranges = processranges(ranges)
    ids
    |> Enum.filter(fn id -> isfresh(String.to_integer(id), validranges) end) |> length
  end

  def processranges(ranges) do
    ranges 
    |> Enum.map(fn str -> str 
      |> String.split("-") 
      |> Enum.map(&String.to_integer/1) 
    end)
  end

  def isfresh(_, []) do
    false
  end
  def isfresh(id, [[left, right] | ranges]) do
    if left <= id && id <= right do
      true
    else
      isfresh(id, ranges)
    end
  end
end
