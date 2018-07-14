class SpaceService
  attr_reader :coordinates

  def initialize(coordinates)
    @space = Space.find_by(name: coordinates)
  end

  def attack!
    @space.result = if !@space.ship_id.nil? && not_attacked?
                @space.ship.damage += 1
                "Hit"
              else
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
    @space.result.nil?
  end
end
