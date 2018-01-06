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

input1 = "paraparaparadise"
input2 = "paragraph"

x = Ngram.char_ngram(input1, 2)
y = Ngram.char_ngram(input2, 2)

# ちなみに、Mapsetを使えば一発でできる
# 上からunion, intersection, difference関数を使う

# 和集合
IO.inspect Enum.concat(x, y)
  |> Enum.uniq

# 積集合
IO.inspect x
  |> Enum.filter(&(&1 in y))
  |> Enum.uniq

# 差集合(x - y)
IO.inspect x
  |> Enum.filter(&(!(&1 in y)))

# "se"があるか調べる
IO.inspect x |> Enum.any?(&(&1 == "se"))
IO.inspect y |> Enum.any?(&(&1 == "se"))
