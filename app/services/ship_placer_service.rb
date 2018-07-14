class ShipPlacerService
  attr_reader :message
  def initialize(board, length, start_space, end_space)
    @board       = board
    @ship        = Ship.create!(length: length, damage: nil)
    @start_space = start_space
    @end_space   = end_space
    ship_place
  end

  def ship_place
    if same_row?
      place_in_row
    elsif same_column?
      place_in_column
    else
      raise InvalidShipPlacement.new("Ship must be in either the same row or column.")
    end
    if @board.ships.count == 2 || @board.ships.count == 3
      @message = "Successfully placed ship with a size of #{@ship.length}. You have 1 ship(s) to place with a size of #{@ship.length == 3 ? (@ship.length - 1) : (@ship.length + 1)}."
    else
      @message = "Successfully placed ship with a size of #{@ship.length}. You have 0 ship(s) to place."
    end
  end

  private
  attr_reader :board, :ship,
    :start_space, :end_space

  def same_row?
    start_space[0] == end_space[0]
  end

  def same_column?
    start_space[1] == end_space[1]
  end

  def place_in_row
    row = start_space[0]
    range = start_space[1]..end_space[1]
    msg = "Ship size must be equal to the number of spaces you are trying to fill."
    raise InvalidShipPlacement.new(msg) unless range.count == ship.length
    range.each { |column| place_ship(row, column) }
  end

  def place_in_column
    column = start_space[1]
    range = start_space[0]..end_space[0]
    msg = "Ship size must be equal to the number of spaces you are trying to fill."
    raise InvalidShipPlacement.new(msg) unless range.count == ship.length
    range.each { |row| place_ship(row, column) }
  end

  def place_ship(row, column)
    coordinates = "#{row}#{column}"
    space = BoardService.new(board).locate_space(coordinates)
    if SpaceService.occupied?(space)
      raise InvalidShipPlacement.new("Attempting to place ship in a space that is already occupied.")
    else
      SpaceService.occupy!(space, ship)
    end
  end
end

class InvalidShipPlacement < StandardError
  def initialize(msg = "Invalid ship placement")
    super
  end
end
