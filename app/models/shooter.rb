class Shooter
  def initialize(board, target)
    @board     = board
    @target    = target
    @message   = ""
  end

  def fire!
    if valid_shot?
      SpaceService.new(@board, @target).attack!
    else
      raise InvalidAttack.new("Invalid coordinates.")
    end
  end

  private
    attr_reader :target

    # def space
    #   @space ||= board.spaces.find_by(name: target)
    # end

    def valid_shot?
      BoardService.space_names.include?(target)
    end
end

class InvalidAttack < StandardError
  def initialize(msg = "Invalid attack.")
    super(msg)
  end
end
