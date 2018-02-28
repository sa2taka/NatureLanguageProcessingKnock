defmodule Json do
  def main(_) do
    filepath = "jawiki-country.json"

    england = File.stream!(filepath)
    |> Enum.to_list
    |> Enum.map(fn s ->
        Poison.decode!(s)
      end
      )
    |> Enum.find(fn json -> json["title"] == "イギリス" end)

    england = england["text"]

    # IO.puts england #20
    # get_category(england) # 21
    # get_category_names(england) #22
    # print_section_with_level(england) #23
    # IO.inspect get_media(england) #24
    # IO.inspect get_foundation_info(england) #25
    # IO.inspect remove_emphasis(england) #26
    # IO.inspect remove_emphasis(england) |> remove_inside_link #27
    # File.write "remove_mark_england.txt", remove_mark(england) #28 #わりと不完全。再帰使ってないから。
    IO.puts get_flag(england) #29 
  end

  def get_category(text) do
    Regex.scan(~r/\[\[Category:.+?\]\]/, text)
    |> IO.inspect
  end

  def get_category_names(text) do
    Regex.scan(~r/Category:([^\]]*)/, text)
    |> Enum.map(&(&1 |> Enum.at(1)))
    |> IO.inspect
  end

  def print_section_with_level(text) do
    Regex.scan(~r/(==+)\s*(.+?)\s*==+/, text)
    |> Enum.map(fn m ->
      eq = Enum.at(m, 1)
      [(Regex.scan(~r/=/, eq) |> Enum.count) - 1, Enum.at(m, 2)]
    end)
    |> IO.inspect
  end

  def get_media(text) do
    Regex.scan(~r/ファイル:(.*?)[|\]]/, text)
    |> Enum.map(&(Enum.at(&1, 1)))
  end

  def get_foundation_info(text) do
    foundation = Regex.run(~r/\{\{基礎情報(.*?)\}\}$/sm, text)
    Regex.scan(~r/\|(.*) = (.*)/, Enum.at(foundation, 1))
    |> Enum.reduce(%{}, fn [_, key, value], acc -> Map.put(acc, key, value) end)
  end

  def remove_emphasis(text) do
    Regex.replace(~r/''+/, text, "")
  end

  def remove_inside_link(text) do
    Regex.replace(~r/\[\[(?:.+?\|)*(.+?)\]\]/, text, "\\1")
  end

  def remove_mark(text) do
    text
    |> remove_emphasis
    |> remove_inside_link
    |> remove_by_regex(~r/#REDIRECT/)
    |> remove_by_regex(~r/\~\~\~\~/)
    |> remove_by_regex(~r/<!--.*?-->/)
    |> remove_by_regex(~r/(==+)(.+?)==+/, "\\2")
    |> remove_by_regex(~r/[\*#]*/)
    |> remove_by_regex(~r/[;:]/)
    |> remove_by_regex(~r/<.*?>/)
  end

  def remove_by_regex(text, regex, replacement \\ "") do
    Regex.replace(regex, text, replacement)
  end

  def get_flag(text) do
    image_path = Regex.scan(~r/国旗画像 = (.*)/, text) |> Enum.at(0) |> Enum.at(1)
    path = "https://commons.wikimedia.org/w/api.php?action=query&titles=File:#{image_path}&prop=imageinfo&iiprop=url&format=json"
    |> String.replace(~r/ /, "%20")
    HTTPoison.start
    case HTTPoison.get! path do
      %HTTPoison.Response { status_code: 200, body: body } ->
        body
    end
    |> Poison.decode!()
    |> get_in(["query", "pages", "347935", "imageinfo"])
    |> Enum.at(0)
    |> Map.get("url")
  end
end
