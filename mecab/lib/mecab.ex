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
    # IO.inspect extract_sequence_noun(mecabs) #35
    # IO.inspect get_frequency(mecabs) |> Enum.map(&(hd(Map.keys &1))) #36

    # get_frequency(mecabs)
    # |> Enum.slice(0..9) #上位10個
    # |> save_data_for_frequency("37.dat") #37

    # get_frequency(mecabs)
    # |> get_histgram
    # |> save_data_for_histgram("38.dat") #38

    get_frequency(mecabs)
    |> save_data_for_zipf("39.dat") #39
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

  def get_frequency(words) do
    Enum.reduce(words, %{}, fn(word, acc) ->
      Map.update(acc, word, 1, &(&1 + 1))
    end)
    |> Enum.sort_by(fn {_, c} -> c end, & >= /2)
    |> Enum.map(fn {w, c} -> %{w[:surface] => c} end)
  end

  def get_histgram(words) do
    Enum.reduce(words, %{}, fn(info, acc) ->
      c = hd(Map.values(info))
      Map.update(acc, c, 1, &(&1 + 1))
    end)
  end

  def save_data_for_frequency(data, filename) do
    Enum.map(data, fn(info) ->
      saved_line = Enum.map(info, fn {w, c} -> w <> "\t" <> Integer.to_string(c) <> "\n" end) |> hd
      File.write!(filename, saved_line, [:append])
    end)
  end

  def save_data_for_histgram(data, filename) do
    Enum.sort_by(data, fn {_, n} -> n end, & >= /2)
    |> Enum.map(fn{c, n} ->
      saved_line = Integer.to_string(c) <> "\t" <> Integer.to_string(n) <> "\n"
      File.write!(filename, saved_line, [:append])
    end)
  end

  def save_data_for_zipf(data, filename) do
    Enum.sort_by(data, fn (info) ->
      c = hd(Map.values(info))
    end, & >= /2)
    Enum.with_index(data)
    |> Enum.map(fn {info, i} ->
      c = hd(Map.values(info))
      File.write!(filename, Integer.to_string(c) <> "\t" <> Integer.to_string(i + 1) <> "\n", [:append])
    end)
  end
end
