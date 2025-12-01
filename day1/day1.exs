defmodule Day1 do
  def main do
    rotations =
      "example.txt"
      |> File.read!()
      |> String.split("\n", trim: true)

    # Only need a few lines to check parsing worked.
    IO.inspect(rotations, pretty: true, limit: 5, label: "Parsed input format")

    final = 
      Enum.reduce(rotations, {50, 0}, fn instruction, {safe_dial, zero_count} ->
        <<direction::binary-size(1), num::binary>> = instruction
        num_value = String.to_integer(num)

        new_total = 
          case direction do
            "L" -> safe_dial - num_value
            "R" -> safe_dial + num_value
          end

        new_safe_dial = Integer.mod(new_total, 100)

        new_zero_count = if new_safe_dial == 0, do: zero_count + 1, else: zero_count
        IO.inspect(new_safe_dial, label: "New safe dial value")

        {new_safe_dial, new_zero_count}
      end)

      IO.inspect(final, label: "Final safe dial value and zero count")
  end
end

Day1.main()
