filepath = "hightemp.txt"

File.stream!(filepath)
|> Enum.to_list
|> Enum.map(&(hd(String.split(&1))))
|> Enum.uniq
|> IO.inspect
