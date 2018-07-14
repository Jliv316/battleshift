module Api
  module V1
    module Games
      class ShotsController < ApiController
        def create
          shooter = User.find_by(api_key: request.headers["HTTP_X_API_KEY"])
          game = Game.find(params[:game_id])
          if (game.current_turn == "Player 1" && game.player_1_id.id == shooter.id) || (game.current_turn == "Player 2" && game.player_2_id.id == shooter.id) && game.winner.nil? || game.current_turn == ""

            turn_processor = TurnProcessorService.new(game, params[:shot][:target], shooter)

            turn_processor.run!
            if turn_processor.message == "Invalid coordinates."
              render json: game, message: turn_processor.message, status: 400 
            else
              if game.boards.where(user_id: shooter.id).first.spaces.pluck(:result).count("Hit") == 5
                game.update(winner: User.find(game.boards.where.not(user_id: shooter.id).first.user_id).username)
                render json: game, message: (turn_processor.message + " Game over.")
              elsif game.boards.where.not(user_id: shooter.id).first.spaces.pluck(:result).count("Hit") == 5
                game.update(winner: shooter.username)
                render json: game, message: (turn_processor.message + " Game over.")
              else
                render json: game, message: turn_processor.message
              end
            end
          elsif !game.winner.nil?
            render json: game, message: "Invalid move. Game over.", status: 400
          else
            render json: game, message: "Invalid move. It's your opponent's turn", status: 400
          end
        end
      end
    end
  end
end
