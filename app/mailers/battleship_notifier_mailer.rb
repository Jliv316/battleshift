class BattleshipNotifierMailer < ApplicationMailer
  def welcome(user, base_url)
    @user = user
    @url = base_url
    mail(to: user.username, subject: "#{user.first_name}, welcome to Battleshift.")
  end

  def register(email, player_1)
    @p1 = player_1
    mail(to: email, subject: "Please create an account to play a game.")
  end

  def invitation(player_1, player_2, game_id, url)
    @url = url
    @p1 = player_1
    @p2 = player_2
    @game_id = game_id
    mail(to: @p2.username, subject: "You have been invited by #{@p1.first_name} to play a game of Battleship.")
  end

  def special_invitation(player_1, player_2, game_id, url)
    @url = url
    @p1 = player_1
    @p2 = player_2
    @game_id = game_id
    mail(to: @p2.username, subject: "You have been invited by #{@p1.first_name} to play a game of Battleship.")
  end
end
