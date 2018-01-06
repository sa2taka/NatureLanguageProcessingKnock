filepath = "hightemp.txt"

File.stream!(filepath)
|> Enum.map(&(hd(String.split(&1))))
|> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
|> Enum.sort_by(fn {_, c} -> c end, &>=/2)
|> IO.inspect
