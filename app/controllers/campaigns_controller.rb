class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.with_attached_cover_image.order(created_at: :desc)
  end

  def show
    @campaign = Campaign.with_attached_cover_image.find(params.expect(:id))
    @recent_donations = @campaign.donations.order(created_at: :desc).limit(6)
    @donation = @campaign.donations.build
  end
end
