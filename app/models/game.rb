class Game < ApplicationRecord
  attr_accessor :messages
  # serialize :player_1_board
  # serialize :player_2_board

  validates :player_1_id, presence: true
  validates :player_2_id, presence: true

  belongs_to :player_1_id, class_name: 'User', foreign_key: 'player_1_id'
  belongs_to :player_2_id, class_name: 'User', foreign_key: 'player_2_id'
  has_many :boards
  has_many :spaces, through: :boards
end
