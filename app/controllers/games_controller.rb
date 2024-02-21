class GamesController < ApplicationController
  def new
    return redirect_to(play_games_path) if @current_game

    @game = Game.new
    @game.players.build
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      initialize_game_and_save_to_session
      redirect_to(play_games_path)
    else
      @game.players.build unless @game.players.any?
      render :new
    end
  end

  def play
    return redirect_to(new_game_path) unless @current_game

    @current_game.start! unless @current_game.started?
  end

  def add_score
    return redirect_to(new_game_path) unless @current_game

    raise
  end

  def destroy
    @current_game.destroy
    REDIS_CLIENT.del(session[:current_anon_user_id])
    redirect_to(new_game_path)
  end

  private

  def game_params
    params.require(:game).permit(:max_score, players_attributes: [:id, :name, :_destroy])
  end

  def initialize_game_and_save_to_session
    @game.initialize_current_next_players!
    session_id = session[:current_anon_user_id] || SecureRandom.urlsafe_base64(nil, false)
    session[:current_anon_user_id] = session_id
    REDIS_CLIENT.set(session_id, @game.id)
  end
end
