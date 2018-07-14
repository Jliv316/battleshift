class SpaceService
  attr_reader :coordinates

  def initialize(board, coordinates)
    @space = board.spaces.find_by(name: coordinates)
  end

  def attack!
    @space.result = if !@space.ship_id.nil? && not_attacked?
                      damage = (@space.ship.damage += 1)
                      @space.ship.update(damage: damage)
                      @space.update(result: "Hit")
                      @space.ship.damage == @space.ship.length ? "Hit. Battleship sunk" : "Hit"
                    else
                      @space.update(result: "Miss")
                      "Miss"
                    end
  end

  def self.occupy!(space, ship)
    space.update(ship_id: ship.id)
  end

  def self.occupied?(space)
    !space.ship_id.nil?
  end

  def not_attacked?
    @space.result == ""
  end
end
