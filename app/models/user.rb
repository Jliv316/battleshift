class User < ApplicationRecord
  has_secure_password
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates_confirmation_of :password
  has_many :games, class_name: 'Game', foreign_key: 'player_1_id'
  has_many :games, class_name: 'Game', foreign_key: 'player_2_id'
  has_many :boards
  has_many :spaces, through: :boards

  def self.generate_api_key
    [*('a'..'z'),*('0'..'9')].shuffle[0,20].join
  end

  # def send_email(user, url)
  #   BattleshipNotifierMailer.welcome(user, url).deliver_now
  # end

  def already_playing?(user)
    games.where('player_2_api_key = ?', user.api_key)
  end

  def find_board(game)
    boards.find_by(game_id: game.id)
  end
end
