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
    print_section_with_level(england) #23
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
end
