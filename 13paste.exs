filepath1 = "col1.txt"
filepath2 = "col2.txt"
result_path = "paste.txt"

paste = (File.read!(filepath1) |> String.trim) <>
"\t" <>
(File.read!(filepath2) |> String.trim)
File.write(result_path, paste)
