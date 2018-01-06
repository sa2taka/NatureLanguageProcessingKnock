input1 = "パトカー"
input2 = "タクシー"

IO.puts Enum.zip(String.codepoints(input1), String.codepoints(input2))
  |> Enum.flat_map(fn {v1, v2} -> [v1, v2] end)
  |> Enum.join
