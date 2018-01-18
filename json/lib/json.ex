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
    get_category(england) # 21
  end

  def get_category(text) do
    Regex.scan(~r/\[\[Category:.+?\]\]/, text)
    |> IO.inspect
  end

end
