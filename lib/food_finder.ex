defmodule FoodFinder do
  @moduledoc """
  Food Finder 
  This is the main entry point of the application. It is comprised of two functions: 

  read_food_trucks/1 - digests the CSV in the priv/ directory

  start/1 - handles selection and decorative outputs
  """
  alias NimbleCSV.RFC4180, as: CSV
  alias FoodFinder.FoodTruck
  alias FoodFinder.IO, as: Prompt

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

  @type opts :: %{
    test: boolean()
  }

  @spec start(opts()) :: :ok
  def start(opts \\ %{}) do
    unless Map.get(opts, :test, false) do 
      IO.puts"======== Initializing Suspense Engine... ========"
    end
    Prompt.roll_dice(opts)

    unless Map.get(opts, :test, false) do 
      IO.puts"======== The pick is in! ========"
    end

    @food_truck_path
    |> read_food_trucks()
    |> Enum.random()
    |> Prompt.dump_truck(opts)
  end
end
