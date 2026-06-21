require "rails_helper"

RSpec.describe Campaign, type: :model do
  let(:campaign) { create(:campaign, title: "Clinic Build", goal_amount_cents: 20_000_00) }

  it "is created succesfully" do
    expect(campaign).to be_valid
  end

  describe "#amount_raised_cents" do
    before do
      create(:campaign_donation_stat, campaign:, user_email: "donor@example.com", amount_cents: 25_000)
    end

    it "returns the sum of the campaigns raised donations" do
      expect(campaign.amount_raised_cents).to eq(25_000)
      expect(campaign.donors_count).to eq(1)
    end
  end
end
