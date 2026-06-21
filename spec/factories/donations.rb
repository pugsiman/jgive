FactoryBot.define do
  factory :donation do
    campaign
    amount_cents { 5_000 }
    giving_frequency { "one_time" }
    donor_display_preference { "anonymous" }
    donor_first_name { "Donor" }
    donor_last_name { "Example" }
    sequence(:user_email) { |number| "donor#{number}@example.com" }

    trait :paid do
      state { "paid" }
    end

    trait :with_dedication_message do
      dedication_message { "In honor of the volunteers." }
    end
  end
end
