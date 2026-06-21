require "rails_helper"

RSpec.describe Donation, type: :model do
  let(:campaign) { create(:campaign, title: "School Supplies Drive") }

  it "defaults new donation records to pending" do
    donation = create(:donation, campaign:, user_email: "Donor@Example.com")

    expect(donation).to be_pending
  end

  it "records campaign donation stats when created" do
    expect do
      create(:donation, campaign:, amount_cents: 2_500, donor_display_preference: "full_name",
                        user_email: "donor@example.com")
    end.to change(campaign.campaign_donation_stats, :count).by(1)
  end
end
