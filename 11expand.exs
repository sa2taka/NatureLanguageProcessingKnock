filepath = "hightemp.txt"
File.read!(filepath)
|> String.replace("\t", " ")
|> IO.puts
