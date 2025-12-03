Code.require_file("../utils/utils.ex")

defmodule Day3 do
  def bank_to_list(bank) do
    bank_as_list = 
      bank
      |> String.split("")
      |> Enum.reject(fn val ->
        if val === "" do
          true
        else
          false
        end
      end)
      |> Enum.map(fn val ->
        String.to_integer(val)
      end)
  end

  def get_index_of_digit(digit_enum, digit) do
    index_of_max_digit = 
      digit_enum
      |> Enum.find_index(fn val ->
        if val === digit do
          true
        else
          false
        end
      end)
  end

  def analyse_bank(bank) do
    # Find the highest digit in the sequence
    # that is not the very final digit. Note
    # their indexes. Check everything to the
    # right of it and once again find the highest
    # digit and combine together.
    bank_as_list = bank |> bank_to_list()
    IO.inspect(bank_as_list, label: "bank")
    # Get the first digit.
    # Check all but the last digit when searching for the
    # best first digit
    first_digit = 
      bank_as_list
      |> Enum.drop(-1)
      |> Enum.max()

    # Get the second digit.
    # Get the index of the first digit, get a slice
    # that starts at the next element, and repeat.
    index_of_max_digit = bank_as_list |> get_index_of_digit(first_digit)

    second_digit = 
      bank_as_list
      |> Enum.drop(index_of_max_digit + 1)
      |> Enum.max()

    max_joltage = 
      [first_digit, second_digit]
      |> Enum.map(fn val ->
        to_string(val)
      end)
      |> Enum.join()
      |> String.to_integer()

    IO.inspect(max_joltage, label: "Max Joltage")
  end

  def analyse_bank_12_digits(bank) do
    # Do the same process as part_1,
    # but start from further left and
    # gradually move over.
    max_joltage = 
      bank
      |> bank_to_list()
      |> build_joltage([], [])
      |> Enum.map(fn val ->
        to_string(val)
      end)
      |> Enum.join()
      |> String.to_integer()

    IO.inspect(max_joltage, label: "Max Joltage", charlists: :as_lists)

  end

  # Let it be known - this absolute tangle of conditionals and 
  # recursion worked perfectly on its first run.
  # I have officially peaked in AoC
  def build_joltage(entire_bank, collected_digits, partial_bank) do
    if length(collected_digits) === 12 do
      collected_digits
    else
      if length(collected_digits) === 0 do
        first_digit =
          entire_bank
          |> Enum.drop(-11)
          |> Enum.max()

        new_digit_collection = collected_digits ++ [first_digit]
        index_of_first_digit = get_index_of_digit(entire_bank, first_digit)
        reduced_bank = entire_bank |> Enum.drop(index_of_first_digit + 1)

        build_joltage(entire_bank, new_digit_collection, reduced_bank)
      else
        next_digit =
          partial_bank
          |> Enum.drop(-(11 - length(collected_digits)))
          |> Enum.max()

        new_digit_collection = collected_digits ++ [next_digit]
        index_of_next_digit = get_index_of_digit(partial_bank, next_digit)
        reduced_bank = partial_bank |> Enum.drop(index_of_next_digit + 1)

        build_joltage(entire_bank, new_digit_collection, reduced_bank)
      end
    end
  end

  def part_1() do
    input = Utils.read_puzzle_input_with_split("input.txt", "\n")
    IO.inspect(input, label: "Parsed input")

    total_joltage = 
      input 
      |> Enum.map(&analyse_bank/1)
      |> Enum.sum()

    IO.inspect(total_joltage, label: "Total joltage", charlists: :as_lists)
  end

  def part_2() do
    input = Utils.read_puzzle_input_with_split("input.txt", "\n")

    total_joltage =
      input
      |> Enum.map(&analyse_bank_12_digits/1)
      |> Enum.sum()

    IO.inspect(total_joltage, label: "Total joltage", charlists: :as_lists)
  end
end

Day3.part_1()
Day3.part_2()
