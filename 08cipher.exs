defmodule Cipher do
  def encrypt(original) do
    String.to_charlist(original)
    |> Enum.map(fn c ->
      if 0x61 <= c && c <= 0x7a do
        219 - c
      else
        c
      end
    end)
    |> List.to_string
  end

  def decrypt(code) do
    encrypt(code)
  end
end

input = "I'm lonely rubyist"
IO.puts "Input: #{input}"

code = Cipher.encrypt(input)

IO.puts code
IO.puts Cipher.decrypt(code)
