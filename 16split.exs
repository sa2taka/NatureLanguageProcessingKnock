filepath = "hightemp.txt"

divided = hd(System.argv) |> String.to_integer
lines = File.stream!(filepath) |> Enum.to_list
line_count = lines |> length
row = line_count / divided

Enum.map(0..divided - 1, fn i ->
  sliced = Enum.slice(lines, round(i * row)..round((i + 1) * row) - 1)
  File.write!("slice#{i}.txt", sliced)
end)
