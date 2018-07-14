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
      # ai_attack_back
      # game.save!
    rescue InvalidAttack => e
      @messages << e.message
    end
  end

  def message
    @messages.join(" ")
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

  # def ai_attack_back
  #   result = AiSpaceSelector.new(player.board).fire!
  #   @messages << "The computer's shot resulted in a #{result}."
  #   game.player_2_turns += 1
  # end

  # def player
  #   Player.new(game.player_1_board)
  # end

  # def opponent
  #   Player.new(game.player_2_board)
  # end
end
