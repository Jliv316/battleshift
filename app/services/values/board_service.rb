class BoardService 
  # Methods to create a board along with creating spaces.
  def self.create_board(player, game, length)
    @length = length
    @board = Board.create(active: true, user_id: player.id, game_id: game.id)
    create_spaces
  end

  def self.get_row_letters
    ("A".."Z").to_a.shift(@length)
  end

  def self.get_column_numbers
    ("1".."26").to_a.shift(@length)
  end

  def self.space_names
    get_row_letters.map do |letter|
      get_column_numbers.map do |number|
        letter + number
      end
    end.flatten
  end

  def self.create_spaces
    space_names.each do |name|
      Space.create!(name: name, board_id: @board.id)
    end
  end

  # End methods to create board and spaces.

  def initialize(board)
    @board = board
  end

  def locate_space(coordinates)
    Space.where(board_id: @board.id).find_by(name: coordinates)
  end

  def space_occupied?(coordinate)
    !Space.find_by(name: coordinate).where(board_id: @board.id).ship_id.nil?
  end

  def space_attacked?(coordinate)
    Space.find_by(name: coordinate).where(board_id: @board.id).result == "Hit" || Space.find_by(name: coordinate).where(board_id: @board.id).result == "Miss"
  end

  def contains_hit?(coordinate)
    Space.find_by(name: coordinate).where(board_id: @board.id).result == "Hit"
  end

  def contains_miss?(coordinate)
    Space.find_by(name: coordinate).where(board_id: @board.id).result == "Miss"
  end

  def first_column?(coordinate)
    get_column(coordinate) == "1"
  end

  def set_spaces_occupied(coordinate1, coordinate2)
    same_row?(coordinate1, coordinate2) ? set_row_spaces_occupied(coordinate1, coordinate2) : set_column_spaces_occupied(coordinate1, coordinate2)
  end
end

