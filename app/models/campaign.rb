class Campaign < ApplicationRecord
  has_one_attached :cover_image

  has_many :donations, dependent: :restrict_with_exception
  has_many :campaign_donation_stats, dependent: :destroy

  validates :title, presence: true
  validates :story, presence: true
  validates :goal_amount_cents, numericality: { greater_than: 0, only_integer: true }

  def amount_raised_cents
    campaign_donation_stats.sum(:amount_cents)
  end

  def progress_percentage
    return 0 if goal_amount_cents.blank? || goal_amount_cents.zero?

    ((amount_raised_cents.to_d / goal_amount_cents) * 100).clamp(0, 100).round
  end

  def donors_count
    campaign_donation_stats.where("donations_count > 0").count
  end
end
