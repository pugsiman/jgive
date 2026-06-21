require "rails_helper"

RSpec.describe "Campaigns", type: :request do
  let!(:campaign) do
    create(:campaign, title: "Winter Relief", story: "Warm clothing and heaters for families.",
                      goal_amount_cents: 15_000_00)
  end

  it "renders a dedicated campaign page" do
    get campaign_path(id: campaign)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include(campaign.title)
  end

  it "creates a pending donation from the campaign page" do
    donation_params = attributes_for(:donation, :with_dedication_message, user_email: "donor@example.com")
                      .except(:amount_cents).merge(preset_amount: "50")

    expect do
      post campaign_donations_path(campaign_id: campaign), params: {
        donation: donation_params
      }
    end.to change(Donation, :count).by(1)

    donation = Donation.last
    expect(response).to redirect_to(campaign_path(id: campaign))
    expect(donation).to be_pending
  end
end
