make_typoglycemia = fn sentence ->
  String.split(sentence)
  |> Enum.map(fn word ->
    if String.length(word) <= 4 do
      word
    else
      (word |>String.at(0)) <>
      (word |> String.slice(1..-2) |> String.codepoints |> Enum.shuffle |> Enum.join) <>
      (word |> String.at(-1))
    end
  end)
  |> Enum.join(" ")
end

input = "I couldn't believe that I could actually understand what I was reading : the phenomenal power of the human mind ."

IO.puts make_typoglycemia.(input)
