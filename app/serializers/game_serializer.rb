class GameSerializer < ActiveModel::Serializer
  attributes :id, :message, :current_turn,
             :player_1_board, :player_2_board

  def player_1_board
    BoardSerializer.new(object.boards.first).attributes
  end

  def player_2_board
    BoardSerializer.new(object.boards.last).attributes
  end

  def message
    require 'pry'; binding.pry
    @instance_options[:message]
  end
end
