defmodule FoodFinder.FoodTruck do
  @moduledoc """
  Although Ecto would have been an appropriate solution for this problem, using a struct felt significantly 
  lighter and easier. Given this whole project is a CLI, less is more.
  """
  alias __MODULE__
  defstruct [:name, :food_items, :address, :schedule, :status]

  def new([
        _location_id,
        name,
        _facility,
        _cnn,
        _loc_desc,
        address,
        _blocklt,
        _block,
        _lot,
        _permit,
        status,
        food_items,
        _x,
        _y,
        _lat,
        _lng,
        _schedule,
        dayshours,
        _noisent,
        _approved,
        _received,
        _ppermit,
        _exp,
        _loc,
        _fpd,
        _pd,
        _sd,
        _zip,
        _neighborhoods
      ]) do
    %FoodTruck{
      name: name,
      food_items: food_items,
      address: address,
      status: status,
      schedule: dayshours
    }
  end
end
