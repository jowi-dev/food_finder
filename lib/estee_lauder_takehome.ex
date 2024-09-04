defmodule EsteeLauderTakehome do
  @moduledoc """
  Documentation for `EsteeLauderTakehome`.
  """
  alias NimbleCSV.RFC4180, as: CSV
  alias EsteeLauderTakehome.FoodTruck
  alias EsteeLauderTakehome.IO, as: Prompt

  @food_truck_path "priv/food_trucks.csv"

  @doc """
  Reads from the given CSV, and returns a list of food trucks that are approved


  In a real world scenario this would probably be an implementation detail that would get mocked out
  in testing. For brevity, I'm going to make this a public function for more direct unit testing
  """
  @spec read_food_trucks(String.t()) :: list(FoodTruck.t())
  def read_food_trucks(path) do
    path
    |> File.stream!(read_ahead: 100_000)
    |> CSV.parse_stream()
    |> Stream.map(&FoodTruck.new/1)
    |> Stream.filter(fn truck -> truck.status == "APPROVED" end)
    |> Enum.to_list()
  end

  @spec start() :: :ok
  def start() do
    Prompt.roll_dice()

    IO.puts"======== The pick is in! ========"
    @food_truck_path
    |> read_food_trucks()
    |> Enum.random()
    |> Prompt.dump_truck()
  end
end
