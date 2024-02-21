class Game < ApplicationRecord
  DEFAULT_MAX_SCORE = 10_000

  has_many :players, dependent: :destroy
  belongs_to :current_player, class_name: "Player", optional: true
  belongs_to :next_player, class_name: "Player", optional: true

  accepts_nested_attributes_for :players, reject_if: :all_blank, allow_destroy: true

  validates :max_score, presence: true
  validates :players, length: { minimum: 1, message: 'should have at least 1 player.' }

  before_create :order_players

  def start!
    update(started_at: Time.zone.now)
  end

  def started?
    started_at.present?
  end

  def finish!
    update(finished_at: Time.zone.now)
  end

  def finished?
    finished_at.present?
  end

  def initialize_current_next_players!
    update!(current_player_id: first_player.id, next_player_id: first_player.next_player.id)
  end

  def first_player
    players.order(:order).first
  end

  private

  def order_players
    players.each_with_index do |player, index|
      player.order = index + 1
    end
  end
end
