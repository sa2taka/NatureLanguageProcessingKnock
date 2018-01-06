input = "Hi He Lied Because Boron Could Not Oxidize Fluorine. New Nations Might Also Sign Peace Security Clause. Arthur King Can."
one_char_atoms = [1, 5, 6, 7, 8, 9, 15, 16, 19]

IO.inspect String.replace(input, ~r/[^\s\w]/, "")
  |> String.split
  |> Enum.with_index(1)
  |> Enum.map(fn {s, i} ->
      if i in one_char_atoms do
        {String.first(s), i}
      else
        {String.slice(s, 0..1), i}
      end
    end)
  |> Enum.into(%{})
