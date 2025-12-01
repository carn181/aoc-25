defmodule D1Test do
  use ExUnit.Case
  doctest D1

  test "greets the world" do
    assert D1.solve1() == 1120
    assert D1.solve2() == 6554
  end
end
