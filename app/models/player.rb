class Player < ApplicationRecord
  belongs_to :game, optional: true

  validates :name, presence: true

  def next_player
    game.players.find_by(order: order + 1) || game.first_player
  end

  def points_to_success
    game.max_score - current_score
  end

  def won?
    current_score == max_score
  end
end
