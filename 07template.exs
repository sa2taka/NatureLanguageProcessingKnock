defmodule Template do
  def getString(x, y, z) do
    "#{x}時の#{y}は#{z}"
  end
end

x = 12
y = "気温"
z = 22.4

IO.puts Template.getString(x, y, z)
