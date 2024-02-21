class ApplicationController < ActionController::Base
  before_action :current_game

  private

  def current_game
    @current_game ||= Game.find_by(id: REDIS_CLIENT.get(session[:current_anon_user_id]))
  end
end
