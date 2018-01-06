defmodule Ngram do
  def word_ngram(str, n) do
    words = String.split(str)
    _ngram(words, n, length(words) - 1, [])
  end

  def char_ngram(str, n) do
    _ngram(String.codepoints(str), n, String.length(str) - 1, [])
    |> Enum.map(&List.to_string/1)
  end

  def _ngram(_, _, remain, acc) when remain == 0 do
    acc
  end

  def _ngram(target, n, remain, acc) do
    result = target |> Enum.slice(remain - 1, n)
    _ngram(target, n, remain - 1, [result | acc])
  end
end

input = "I am an NLPer"

IO.inspect Ngram.word_ngram(input, 2)
IO.inspect Ngram.char_ngram(input, 2)
