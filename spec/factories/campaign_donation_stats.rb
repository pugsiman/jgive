FactoryBot.define do
  factory :campaign_donation_stat do
    campaign
    sequence(:user_email) { |number| "paid-donor#{number}@example.com" }
    amount_cents { 5_000 }
    donations_count { 1 }
  end
end
