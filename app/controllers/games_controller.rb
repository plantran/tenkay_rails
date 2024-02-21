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
    @current_player = @current_game.current_player
  end

  def add_score
    return redirect_to(new_game_path) unless @current_game
    return redirect_to(play_games_path) unless params[:player][:score].presence

    @current_player = @current_game.current_player
    new_score = @current_player.current_score + params[:player][:score].to_i
    if new_score > @current_game.max_score
      update_game_players
    elsif @current_player.update(current_score: new_score)
      @current_game.finish! if new_score == @current_game.max_score
      update_game_players
    end

    # raise
    redirect_to(play_games_path)
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

  def update_game_players
    next_next_player = @current_game.next_player.next_player
    @current_game.update!(current_player_id: @current_game.next_player.id, next_player_id: next_next_player.id)
  end
end
