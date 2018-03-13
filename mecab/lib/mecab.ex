defmodule MecabExtractor do
  def main(_) do
    # neko = File.read! "neko.txt"
    # mecab_to_file(neko, "neko.txt.mecab")
    # 同じ単語を複数使用しない時にはuniqを使うと良いかも知れない
    mecabs = read_neko_mecabs("neko.txt.mecab") #1
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

  end
end
