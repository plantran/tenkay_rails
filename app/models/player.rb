class Player < ApplicationRecord
  belongs_to :game, optional: true

  validates :name, presence: true

  def next_player
    game.players.find_by(order: order + 1) || game.first_player
  end
end
