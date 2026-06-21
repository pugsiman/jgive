module CampaignsHelper
  def currency_from_cents(cents)
    number_to_currency(cents.to_d / 100, unit: "₪", format: "%n %u", precision: 0)
  end

  def donor_display_name(donation)
    return t("campaigns.show.anonymous_donor") if donation.anonymous?
    return donation.donor_first_name.presence || t("campaigns.show.anonymous_donor") if donation.first_name_only?

    [donation.donor_first_name, donation.donor_last_name].compact_blank.join(" ").presence ||
      t("campaigns.show.anonymous_donor")
  end
end
