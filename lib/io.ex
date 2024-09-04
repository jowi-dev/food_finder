defmodule EsteeLauderTakehome.IO do
  @moduledoc """
  This module is mostly.. `pizzaz` because reading a random value from the CSV did not seem 
  charming enough to excite users.
  """
  @dice """
        +---------------+
       /  *    *    *  /|
      /  *         *  / |
     /  *    *    *  /  |
    /               /   |
   /               /    |
  +---------------+     |
  |               |     |
  |   *       *   |     +
  |               |    /
  |   *       *   |   /
  |               |  /
  |   *       *   | /
  |               |/
  +---------------+
  """

  @dice_height 4
  @dice_width 8

  @width 60
  @height 20
  @colors [:red, :yellow, :cyan, :blue, :green]
  # two sides
  @borders_size 2

  @typep dump_opts :: %{
    to_string: boolean()
  }
  @doc """
  Dumps the food truck data into a human readable string

  added opt for easier testing, or incase string dumping is needed
  """
  @spec dump_truck(EsteeLauderTakehome.FoodTruck.t(), dump_opts()) :: String.t()
  def dump_truck(truck, opts \\ %{to_string: false})
  def dump_truck(truck, to_string: true) do 
    """
    Food Truck: #{truck.name}
    Menu: #{truck.food_items}
    Address: #{truck.address}
    """
  end
  def dump_truck(truck, _opts) do 
    name = Owl.Data.tag("Food Truck: #{truck.name}\n", :red)
    menu = Owl.Data.tag("Menu: #{truck.food_items}\n", :green)
    address = Owl.Data.tag("Address: #{truck.address}",:magenta)
    Owl.IO.puts([name, menu, address])
  end

  @doc """
  Builds suspense for the truck selection
  """
  @spec roll_dice() :: :ok
  def roll_dice do
    dice = String.trim_trailing(@dice)

    Owl.LiveScreen.add_block(:demo,
      render: fn
        nil ->
          ""

        state ->
          dice
          |> Owl.Data.tag(state.dice_color)
          |> Owl.Box.new(
            min_width: @width,
            min_height: @height,
            padding_top: state.padding_top,
            padding_left: state.padding_left
          )
          |> Owl.Data.tag(:magenta)
      end
    )

    state = %{
      padding_top: 10,
      padding_left: 30,
      vertical_shift: 1,
      horizontal_shift: -1,
      dice_color: Enum.random(@colors)
    }

    roll(state, 50)
  end

  defp roll(_state, 0), do: :ok

  defp roll(state, time) do
    state = update_dice_state(state)

    Owl.LiveScreen.update(:demo, %{
      padding_left: state.padding_left,
      padding_top: state.padding_top,
      dice_color: state.dice_color
    })

    Process.sleep(70)
    roll(state, time - 1)
  end

  defp update_dice_state(state) do
    state
    |> update_horizontal_shift()
    |> update_veritical_shift()
    |> update_padding()
    |> update_color(state)
  end

  defp update_horizontal_shift(state) do
    horizontal_shift =
      cond do
        state.padding_left == 0 or
            @width - state.padding_left - @dice_width - @borders_size == 0 ->
          state.horizontal_shift * -1

        state.padding_left > 0 ->
          state.horizontal_shift
      end

    Map.put(state, :horizontal_shift, horizontal_shift)
  end

  defp update_veritical_shift(state) do
    vertical_shift =
      cond do
        state.padding_top == 0 or
            @height - state.padding_top - @dice_height - @borders_size == 0 ->
          state.vertical_shift * -1

        state.padding_top > 0 ->
          state.vertical_shift
      end

    Map.put(state, :vertical_shift, vertical_shift)
  end

  defp update_padding(state) do
    Map.merge(state, %{
      padding_left: state.padding_left + state.horizontal_shift,
      padding_top: state.padding_top + state.vertical_shift
    })
  end

  defp update_color(state, old_state) do
    dice_color =
      if old_state.vertical_shift != state.vertical_shift or
           old_state.horizontal_shift != state.horizontal_shift do
        Enum.random(@colors)
      else
        state.dice_color
      end

    Map.put(state, :dice_color, dice_color)
  end
end
