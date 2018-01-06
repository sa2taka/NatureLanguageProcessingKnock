filepath = "hightemp.txt"
File.stream!(filepath)
|> Enum.to_list
|> length
|> IO.inspect
