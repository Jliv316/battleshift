class TurnProcessorService
  def initialize(game, target, shooter)
    @game   = game
    @target = target
    @messages = []
    @shooter = shooter
    @opponent_board = game.boards.where.not(user_id: shooter.id).first
  end

  def run!
    begin
      attack_opponent
    rescue InvalidAttack => e
      @messages << e.message
    end
  end

  def message
    @messages.join(" ")
  end

  def check_win_conditions
    if @game.boards.where(user_id: @shooter.id).first.spaces.pluck(:result).count("Hit") == 5
      @game.update(winner: User.find(@game.boards.where.not(user_id: @shooter.id).first.user_id).username)
    elsif @game.boards.where.not(user_id: @shooter.id).first.spaces.pluck(:result).count("Hit") == 5
      @game.update(winner: @shooter.username)
    end
  end

  private

  attr_reader :game, :target, :opponent_board, :shooter

  def attack_opponent
    result = Shooter.new(@opponent_board, @target).fire!
    @messages << "Your shot resulted in a #{result}."
    if game.player_1_id.id == @shooter.id
      game.player_1_turns += 1
      game.update(current_turn: "Player 2")
    else
      game.player_2_turns += 1
      game.update(current_turn: "Player 1")
    end
  end

  def invalid_move_or_turn?

  end
end
