Code.require_file("../utils/utils.ex")

defmodule Day2 do
  def read_puzzle_input() do
    input = Utils.read_puzzle_input_with_split("input.txt", ",")
    Enum.map(input, fn val ->
      val
      |> String.trim()
      |> String.split("-", parts: 2)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def get_invalid_ids_from_range(id_range) do
    start = id_range |> elem(0)
    finish = id_range |> elem(1)

    Enum.filter(start..finish, fn product_id ->
      product_id_len = 
        product_id
        |> Integer.digits()
        |> length()

      if Integer.mod(product_id_len, 2) == 0 do
        str_product_id = product_id |> to_string()
        {left, right} = String.split_at(str_product_id, div(String.length(str_product_id), 2))
        if left === right do
          true
        else
          false
        end
      else
        false
      end
    end)
  end

  def part_1() do
    input = read_puzzle_input()
    IO.inspect(input, pretty: true, label: "Parsed puzzle input")
    # IDs are only invalid if they are made ONLY up of the same
    # sequence of digits repeated twice. This means two things:
    # - We can instantly rule out IDs with an odd number of digits
    # - We simply half the IDs with an even number of digits and check.

    # Transform each tuple into a list of invalid IDs in that range.
    invalid_id_lists = Enum.map(input, &get_invalid_ids_from_range/1)

    IO.inspect(invalid_id_lists, label: "Invalid IDs", charlists: :as_lists)

    invalid_id_totals = 
      Enum.map(invalid_id_lists, fn id_list ->
        Enum.reduce(id_list, 0, fn val, total -> total + val end)
      end)

    IO.inspect(invalid_id_totals, label: "Invalid ID totals for each range")

    final_total = Enum.reduce(invalid_id_totals, 0, fn val, total -> total + val end)
    IO.inspect(final_total, label: "Final Invalid ID total")
    
  end

  def get_factors_of_num(num) do
    # We only need to check up to halfway to the number,
    # since the pattern has to repeat at LEAST twice.
    # That lets us know the longest a substring can be
    # is half the length of the full thing.
    Enum.filter(1..num, fn val ->
      if Integer.mod(num, val) == 0 and val != num do
        true
      else
        false
      end
    end)
  end

  def is_invalid_id(product_id) do
    str_product_id = product_id |> to_string()

    product_id_len = 
      product_id
      |> Integer.digits()
      |> length()

    len_factors = get_factors_of_num(product_id_len)

    valid_factor =
      Enum.find(len_factors, -1, fn val ->
        {left, _right} = String.split_at(str_product_id, val)
        multiplier = div(product_id_len, val)
        sequenced_id = String.duplicate(left, multiplier)
        if sequenced_id === str_product_id do
          true
        else
          false
        end
      end)

    if valid_factor === -1 do
      false
    else
      true
    end
  end

  def get_invalid_ids_with_new_rule(id_range) do
    start = id_range |> elem(0)
    finish = id_range |> elem(1)

    Enum.filter(start..finish, &is_invalid_id/1)
  end

  def part_2() do
    input = read_puzzle_input()
    # Part 2 now forces us to check different lengths of substrings.
    # The one saving grace is the substring still has to cleanly make up
    # the entire sequence. If we get the length of each candidate, we can
    # brute force checking the IDs using string concatenation/multiplication.
    invalid_id_lists = Enum.map(input, &get_invalid_ids_with_new_rule/1)
    invalid_id_totals = 
      Enum.map(invalid_id_lists, fn id_list ->
        Enum.reduce(id_list, 0, fn val, total -> total + val end)
      end)

    IO.inspect(invalid_id_totals, label: "Invalid ID totals for each range")

    final_total = Enum.reduce(invalid_id_totals, 0, fn val, total -> total + val end)
    IO.inspect(final_total, label: "Final Invalid ID total")
  end
end

Day2.part_1()
Day2.part_2()
