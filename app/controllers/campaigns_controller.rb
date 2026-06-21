class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.with_attached_cover_image.order(created_at: :desc)
  end

  def show
    @campaign = Campaign.with_attached_cover_image.find(params.expect(:id))
    @donation = @campaign.donations.build
  end
end
