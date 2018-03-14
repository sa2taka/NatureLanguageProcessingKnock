defmodule MecabExtractor do
  def main(_) do
    # neko = File.read! "neko.txt"
    # mecab_to_file(neko, "neko.txt.mecab")
    # 同じ単語を複数使用しない時にはuniqを使うと良いかも知れない
    mecabs = read_neko_mecabs("neko.txt.mecab") #30
    # IO.inspect extract_verb(mecabs) #31
    # IO.inspect extract_base(mecabs) #32
    # IO.inspect extract_sahen(mecabs) #33
    # IO.inspect extract_linked_with_no(mecabs) #34
    IO.inspect extract_sequence_noun(mecabs)
  end

  def mecab_to_file(str, filename) do
    Mecab.parse(str)
    |> Enum.map(fn(word) ->
      %{"surface_form" => surface,
      "lexical_form" => base,
      "part_of_speech" => pos,
      "part_of_speech_subcategory1" => pos1} = word
      saved_line = surface <> "\t" <> base <> "\t" <> pos <> "\t" <> pos1 <> "\n"
      File.write!(filename, saved_line, [:append])
    end)
  end

  def read_neko_mecabs(filename) do
    File.stream!(filename)
    |> Enum.to_list
    |> Enum.map(fn(mecab_str) ->
      elms = String.split(mecab_str, "\t")
      [surface, base, pos, pos1] = elms
      pos1 = String.trim(pos1)
      %{ :surface => surface, :base => base, :pos => pos, :pos1 => pos1 }
    end)
  end

  def extract_verb(words) do
    Enum.uniq(words)
    |> Enum.reduce([], fn(word, acc) ->
      if word[:pos] == "動詞" do
        [word[:surface] | acc]
      else
        acc
      end
    end)
  end

  def extract_base(words) do
    Enum.uniq_by(words, &(&1[:base]))
    |> Enum.reduce([], fn(word, acc) ->
      if word[:pos] == "動詞" do
        [word[:base] | acc]
      else
        acc
      end
    end)
  end

  def extract_sahen(words) do
    Enum.uniq(words)
    |> Enum.reduce([], fn(word, acc) ->
      if word[:pos1] == "サ変接続" do
        [word[:surface] | acc]
      else
        acc
      end
    end)
  end

  def extract_linked_with_no(words, acc \\ [], window \\ []) when length(words) != 0 do
    window = window ++ [hd(words)]
    words = tl(words)
    if length(window) == 3 do
      [first, second, third] = window
      if Enum.map(window, &(&1[:pos])) == ["名詞", "助詞", "名詞"] && second[:surface] == "の" do
        acc = [first[:surface] <> second[:surface] <> third[:surface] | acc]
      end
      window = tl(window)
    end
    extract_linked_with_no(words, acc, window)
  end

  def extract_linked_with_no(words, acc, window) do
    acc
  end

  def extract_sequence_noun(words, acc \\ [], work \\ "", matched_num \\ 0) when length(words) != 0 do
    now_word = hd(words)
    words = tl(words)
    if now_word[:pos] == "名詞"do
      work = work <> now_word[:surface]
      matched_num = matched_num + 1
    else
      if matched_num >= 2 do
        acc = [work | acc]
      end
      matched_num = 0
      work = ""
    end
    extract_sequence_noun(words, acc, work, matched_num)
  end

  def extract_sequence_noun(words, acc, work, matched_num) do
    acc
  end
end
