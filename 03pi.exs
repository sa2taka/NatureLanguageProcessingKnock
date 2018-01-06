input = "Now I need a drink, alcoholic of course, after the heavy lectures involving quantum mechanics."

IO.inspect String.replace(input, ~r/[^\s\w]/, "")
  |> String.split
  |> Enum.map(fn x -> String.length(x) end)
