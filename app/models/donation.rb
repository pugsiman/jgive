class Donation < ApplicationRecord
  PRESET_AMOUNTS = [25, 50, 100, 250].freeze

  belongs_to :campaign

  enum :giving_frequency, { one_time: "one_time", recurring: "recurring" }, validate: true
  enum :donor_display_preference,
       { full_name: "full_name", first_name_only: "first_name_only", anonymous: "anonymous" },
       validate: true
  enum :state, { pending: "pending", paid: "paid" }, validate: true

  before_validation :normalize_user_email
  after_create :add_to_donation_stats

  validates :amount_cents, numericality: { greater_than: 0, only_integer: true }
  validates :donor_first_name, :donor_last_name, presence: true, unless: :anonymous?
  validates :user_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  private

  def normalize_user_email
    self.user_email = user_email.to_s.strip.downcase
  end

  def add_to_donation_stats
    CampaignDonationStat.record_donation!(
      campaign_id: campaign_id,
      user_email: user_email,
      amount_cents: amount_cents
    )
  end
end
