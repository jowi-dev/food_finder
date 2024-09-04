defmodule FoodFinderTest do
  use ExUnit.Case
  doctest FoodFinder 

  # incase we want to mock this later
  @food_truck_path "priv/food_trucks.csv"

  test "reads lines from csv" do
    assert 0 <
             @food_truck_path
             |> FoodFinder.read_food_trucks()
             |> Enum.count()
  end

  test "only pulls approved food trucks" do
    assert @food_truck_path
           |> FoodFinder.read_food_trucks()
           |> Enum.all?(fn truck -> truck.status == "APPROVED" end)
  end

  # Skipping because there is no overlap between approved food trucks and food trucks with a dayshours schedule
  @tag :skip
  test "only pulls food trucks with a schedule for easier picking" do
    assert @food_truck_path
           |> FoodFinder.read_food_trucks()
           |> Enum.all?(fn truck -> not is_nil(truck.schedule) and truck.schedule != "" end)
  end


  test "outputs a string representation of a food truck" do 
    output = FoodFinder.start(%{test: true})

    assert output =~ "Food Truck: " 
    assert output =~ "Menu: " 
    assert output =~ "Address: " 
  end
end
