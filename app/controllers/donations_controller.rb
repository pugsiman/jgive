class DonationsController < ApplicationController
  DONATION_FORM_ATTRIBUTES = %i[
    preset_amount
    custom_amount
    giving_frequency
    donor_display_preference
    dedication_message
    donor_first_name
    donor_last_name
    user_email
  ].freeze

  AMOUNT_PARAMS = %w[preset_amount custom_amount].freeze

  def create
    @campaign = Campaign.find(params.expect(:campaign_id))
    @donation = @campaign.donations.build(donation_params)

    if @donation.save
      # Future payment integration should call PaymentService here and only mark
      # the donation paid after the provider confirms the charge.
      redirect_to campaign_path(id: @campaign), notice: t(".pledge_recorded")
    else
      render "campaigns/show", status: :unprocessable_content
    end
  end

  private

  def donation_params
    form_params = params.expect(donation: DONATION_FORM_ATTRIBUTES)
    selected_amount = form_params[:custom_amount].presence || form_params[:preset_amount]

    form_params.except(*AMOUNT_PARAMS).merge(amount_cents: amount_cents(selected_amount))
  end

  def amount_cents(amount)
    return if amount.blank?

    (BigDecimal(amount) * 100).round
  rescue ArgumentError
    nil
  end
end
