defmodule D6 do
  @doc """
  """
  def solve1 do
    "input.txt"
    |> process()
    |> totalcalculate(&calculate(&1, false))
  end
  
  def solve2 do
    "input.txt"
    |> process()
    |> totalcalculate(&calculate(&1, true))
  end

  def process(file) do
    file
    |> File.read!()
    |> String.split("\n")
    |> List.delete_at(-1)
    |> Enum.map(&String.graphemes/1)
  end
  
  def totalcalculate(exprs, calc_fn) do
    exprs
    |> transpose()
    |> split([" ", " ", " ", " ", " "])
    |> Enum.map(&D6.transpose/1)
    |> Enum.map(calc_fn)
    |> Enum.sum()
  end
  
  def calculate(lst, transpose?) do
    last = List.last(lst) |> List.to_string() |> String.trim()
    nums = Enum.drop(lst, -1)

    nums
    |> (fn x -> if transpose?, do: transpose(x), else: x end).()
    |> Enum.map(fn x -> x |> List.to_string() |> String.trim() |> String.to_integer() end)
    |> Enum.reduce(id(last), oper(last))
  end


  def oper(str) do
    case str do
      "+" -> &+/2
      "*" -> &*/2
    end
  end

  def id(str) do
    case str do
      "+" -> 0
      "*" -> 1
    end
  end

  def transpose(lst) do
    lst |> Enum.zip() |> Enum.map(&Tuple.to_list/1)
  end

  def split(lst, split_val) do
    lst
    |> Enum.chunk_by(&(&1 == split_val))
    |> Enum.reject(&(&1 == [split_val]))
  end
end
