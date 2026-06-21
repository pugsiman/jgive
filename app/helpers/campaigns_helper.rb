module CampaignsHelper
  def currency_from_cents(cents)
    number_to_currency(cents.to_d / 100, unit: "₪", format: "%n %u", precision: 0)
  end
end
