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

  def get_spaces_between(coordinate1, coordinate2)
    return get_row_spaces_between(coordinate1, coordinate2) if same_row?(coordinate1, coordinate2)
    return get_column_spaces_between(coordinate1, coordinate2) if same_column?(coordinate1, coordinate2)
  end

  def get_row_spaces_between(coordinate1, coordinate2)
    columns = (get_smaller_column(coordinate1, coordinate2)..get_bigger_column(coordinate1, coordinate2)).to_a
    columns.map { |column| get_row(coordinate1) + column }
  end

  def get_column_spaces_between(coordinate1, coordinate2)
    rows = (get_smaller_row(coordinate1, coordinate2)..get_bigger_row(coordinate1, coordinate2)).to_a
    rows.map { |row| row + get_column(coordinate1) }
  end

  def get_bigger_column(coordinate1, coordinate2)
    get_column(coordinate1).to_i > get_column(coordinate2).to_i ? get_column(coordinate1) : get_column(coordinate2)
  end

  def get_smaller_column(coordinate1, coordinate2)
    get_column(coordinate1).to_i < get_column(coordinate2).to_i ? get_column(coordinate1) : get_column(coordinate2)
  end

  def get_bigger_row(coordinate1, coordinate2)
    get_row(coordinate1) > get_row(coordinate2) ? get_row(coordinate1) : get_row(coordinate2)
  end

  def get_smaller_row(coordinate1, coordinate2)
    get_row(coordinate1) < get_row(coordinate2) ? get_row(coordinate1) : get_row(coordinate2)
  end

  def get_row(coordinate)
    coordinate.split("")[0]
  end

  def get_column(coordinate)
    coordinate[1..-1]
  end

  def get_horizontal_length(coordinate1, coordinate2)
    return false if !same_row?(coordinate1, coordinate2)
    column1 = get_column(coordinate1).to_i
    column2 = get_column(coordinate2).to_i
    column1 > column2 ? (column1 - column2) + 1 : (column2 - column1) + 1
  end

  def get_vertical_length(coordinate1, coordinate2)
    return false if !same_column?(coordinate1, coordinate2)
    row1 = get_row_letters.index(get_row(coordinate1))
    row2 = get_row_letters.index(get_row(coordinate2))
    row1 > row2 ? (row1 - row2) + 1 : (row2 - row1) + 1
  end

  def contains?(coordinate)
    BoardService.space_names.include?(coordinate)
  end

  def same_row?(coordinate1, coordinate2)
    get_row(coordinate1) == get_row(coordinate2)
  end

  def same_column?(coordinate1, coordinate2)
    get_column(coordinate1) == get_column(coordinate2)
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

  # def n_spaces_to_rows
  #   space_names.each_slice(@length).to_a
  # end

  # def e_grid
  #   spaces = create_spaces
  #   assign_spaces_to_rows.map do |row|
  #     row.each.with_index do |coordinates, index|
  #       row[index] = {coordinates => spaces[coordinates]}
  #     end
  #   end
  # end

  # def self.initialize(player, game, length)
  #   @length = length
  #   @board = Board.create(active: true, user_id: player.id, game_id: game.id)
  #   create_spaces
  #   # @board = create_grid
  # end

   # def set_space_occupied(coordinate, ship)
  #   Space.find_by(name: coordinate, board_id: @board.id).ship_id = ship.id
  # end

  # def set_column_spaces_occupied(coordinate1, coordinate2)
  #   get_column_spaces_between(coordinate1, coordinate2).each do |coordinate|
  #     set_space_occupied(coordinate)
  #   end
  # end

  # def set_row_spaces_occupied(coordinate1, coordinate2)
  #   get_row_spaces_between(coordinate1, coordinate2).each do |coordinate|
  #     set_space_occupied(coordinate)
  #   end
  # end

  # def set_space_attacked(coordinate)
  #   Space.find_by(name: coordinate, board_id: @board.id) = true
  # end
  
  # def has_north_neighbor?(coordinate)
  #   get_row_letters.index(get_row(coordinate)) > 0
  # end
  
  # def has_south_neighbor?(coordinate)
  #   get_row_letters.index(get_row(coordinate)) < @length - 1
  # end
  
  # def has_east_neighbor?(coordinate)
  #   (coordinate[1..-1].to_i > 0) && (coordinate[1..-1].to_i < @length)
  # end
  
  # def has_west_neighbor?(coordinate)
  #   coordinate[1..-1].to_i > 1
  # end
  
  # def get_north_neighbor(coordinate)
  #   get_row_letters[get_row_letters.index(get_row(coordinate)) - 1] + get_column(coordinate)
  # end
  
  # def get_south_neighbor(coordinate)
  #   get_row_letters[get_row_letters.index(get_row(coordinate)) + 1] + get_column(coordinate)
  # end
  
  # def get_east_neighbor(coordinate)
  #   get_row(coordinate) + (get_column(coordinate).to_i + 1).to_s
  # end

  # def get_west_neighbor(coordinate)
  #   get_row(coordinate) + (get_column(coordinate).to_i - 1).to_s
  # end

  # def neighbors(coordinate)
  #   neighbors = []
  #   neighbors << get_north_neighbor(coordinate) if has_north_neighbor?(coordinate)
  #   neighbors << get_east_neighbor(coordinate) if has_east_neighbor?(coordinate)
  #   neighbors << get_south_neighbor(coordinate) if has_south_neighbor?(coordinate)
  #   neighbors << get_west_neighbor(coordinate) if has_west_neighbor?(coordinate)
  #   return neighbors
  # end

  # def neighbors?(coordinate1, coordinate2)
  #   neighbors(coordinate1).include?(coordinate2)
  # end
end

