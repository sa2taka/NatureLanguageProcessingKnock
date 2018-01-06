filepath = "hightemp.txt"

File.stream!(filepath)
|> Enum.to_list
|> Enum.sort_by(fn line -> String.split(line) |> Enum.at(2) end, &>=/2)
|> Enum.join
|> IO.puts
