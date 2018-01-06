input = "パタトクカシーー"
IO.puts String.codepoints(input)
  |> Enum.take_every(2)
  |> Enum.join
