defmodule EsteeLauderTakehome.IOTest do 
  use ExUnit.Case

  test "prints a food truck's name, address and menu" do 
    truck = %EsteeLauderTakehome.FoodTruck{
      name: "Bob's Burgers",
      food_items: "Burgers",
      address: "La Puente, California"
    }
    assert """
    Food Truck: Bob's Burgers
    Menu: Burgers
    Address: La Puente, California
    """ = EsteeLauderTakehome.IO.dump_truck(truck, to_string: true)
  end

end
