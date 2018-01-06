filepath = "hightemp.txt"

lines = File.stream!(filepath) |> Enum.to_list
line_count = lines |> length

# 引数がなければ初期値5を与える
# 行数を超えていれば最大行数にする
n = case System.argv |> Enum.map(&String.to_integer/1) do
  [n | _] when n >= line_count -> line_count
  [n | _] -> n
  _ -> 5
end

lines
|> Enum.slice(-n..-1)
|> Enum.join
|> String.trim
|> IO.puts
