class CampaignDonationStat < ApplicationRecord
  belongs_to :campaign

  validates :user_email, presence: true
  validates :amount_cents, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :donations_count, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  class << self
    def record_donation!(campaign_id:, user_email:, amount_cents:)
      stat = create_or_find_by!(campaign_id:, user_email:)

      update_counters(stat.id, amount_cents: amount_cents, donations_count: 1)
    end
  end
end
