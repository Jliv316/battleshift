module Api
  module V1
    class GamesController < ApiController
      def show
        game = Game.find(params[:id])
        render json: game
      end

      def create
        p1 = User.find_by(api_key: game_params[:api_key])
        p2 = User.find_by(username: game_params[:player_2_username])
        if p2.nil?
          player_2_not_registered(game_params[:player_2_username], p1)
        elsif !p2.activated
          player_not_activated(p2)
        elsif !p1.activated
          player_not_activated(p1)
        else
          game = Game.create(player_1_id: p1, player_2_id: p2, player_1_api_key: p1.api_key, player_2_api_key: p2.api_key)
          invite_player_2(p1, p2, game)
          BoardService.create_board(p1, game, 4)
          BoardService.create_board(p2, game, 4)
        end
      end

      private

      def game_params
        params.require(:game).permit(:api_key, :player_2_username)
      end

      def player_not_activated(player)
        BattleshipNotifierMailer.welcome(player, request.base_url).deliver_now
        if player.username == game_params[:player_2_username]
          render json: { message: "You're opponent must activate their account before you can play a game. They have been sent an activation email."}, status: 400
        else
          render json: { message: "You must activate your account before you can play a game. Check your email for another activation email."}, status: 400
        end
      end

      def player_2_not_registered(p2_email, p1)
        BattleshipNotifierMailer.register(p2_email, p1).deliver_now
        render json: { message: "Your opponent must create an account before you can play a game. They can check their email for a registration link."}, status: 400
      end

      def invite_player_2(p1, p2, game)
        BattleshipNotifierMailer.invitation(p1, p2, game, request.base_url).deliver_now
        render json: { message: "#{p2.first_name} has been invited to play a game of Battleship with you.", id: "#{game.id}" }
      end
    end
  end
end
