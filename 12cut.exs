filepath = "hightemp.txt"
File.stream!(filepath)
|> Enum.to_list
|> Enum.with_index
|> Enum.map(fn {s, i} ->
  if i in [0, 1] do
    File.write("col#{i + 1}.txt", s)
  end
end)
