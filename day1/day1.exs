defmodule Day1 do
  def main do
    rotations =
      "input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)

    # Only need a few lines to check parsing worked.
    IO.inspect(rotations, pretty: true, limit: 5, label: "Parsed input format")

    final = 
      Enum.reduce(rotations, {50, 0}, fn instruction, {safe_dial, zero_count} ->
        <<direction::binary-size(1), num::binary>> = instruction
        num_value = String.to_integer(num)
        started_on_zero = if safe_dial == 0, do: 1, else: 0

        # Take the mod of the number of instructions, since moving by 100 is the
        # same as moving by 0. We'll use the mod count to check how many times we
        # will pass 0 REGARDLESS of the current dial value, then check further down
        # in case we pass 0 again carrying out the "reduced" instruction. Then of
        # course tack on 1 more if we end on 0 too.
        reduced_num_value = Integer.mod(num_value, 100)
        definite_zero_passes = div(num_value, 100)

        IO.inspect(num_value, label: "Parsed num value")
        IO.inspect(direction, label: "Direction")
        IO.inspect(reduced_num_value, label: "Instruction mod 100")
        IO.inspect(definite_zero_passes, label: "Instruction div 100")

        new_total = 
          case direction do
            "L" -> safe_dial - reduced_num_value
            "R" -> safe_dial + reduced_num_value
          end

        new_safe_dial = Integer.mod(new_total, 100)
        IO.inspect(new_safe_dial, label: "New safe dial value")

        # Now add number of definite zero passes, if the mod has changed, and if we end on 0.
        # We already have the definite zero passes up above, now we just need the other two.
        ended_on_zero = if new_safe_dial == 0, do: 1, else: 0
        IO.inspect(ended_on_zero, label: "Ended on 0?")
        potential_extra_pass = if (started_on_zero != 1 ) and (ended_on_zero != 1) and (new_safe_dial != new_total), do: 1, else: 0
        IO.inspect(potential_extra_pass, label: "Passed 0?")

        new_zero_count = zero_count + definite_zero_passes + potential_extra_pass + ended_on_zero
        IO.inspect(new_zero_count, label: "New zero count")
        IO.puts("")

        {new_safe_dial, new_zero_count}
      end)

      IO.inspect(final, label: "Final safe dial value and zero count")
  end
end

Day1.main()
