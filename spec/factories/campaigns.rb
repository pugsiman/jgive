FactoryBot.define do
  factory :campaign do
    sequence(:title) { |number| "Campaign #{number}" }
    story { "Funding direct support for people in need." }
    goal_amount_cents { 10_000_00 }
  end
end
