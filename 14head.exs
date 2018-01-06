filepath = "hightemp.txt"
# 引数がなければ初期値5を与える
n = case System.argv do
  [n | _] -> String.to_integer(n)
  _ -> 5
end

File.stream!(filepath)
|> Enum.to_list
|> Enum.with_index(1)
|> Enum.map(fn {s, i} ->
  if i in 1..n do
    IO.puts s |> String.trim
  end
end)
