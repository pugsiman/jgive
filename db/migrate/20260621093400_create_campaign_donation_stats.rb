class CreateCampaignDonationStats < ActiveRecord::Migration[8.0]
  def change
    create_table :campaign_donation_stats do |t|
      t.references :campaign, null: false, foreign_key: true
      t.string :user_email, null: false
      t.bigint :amount_cents, null: false, default: 0
      t.integer :donations_count, null: false, default: 0

      t.timestamps
    end

    add_index :campaign_donation_stats, %i[campaign_id user_email], unique: true

    add_check_constraint :campaign_donation_stats, "amount_cents >= 0",
                         name: "campaign_donation_stats_amount_nonnegative"
    add_check_constraint :campaign_donation_stats, "donations_count >= 0",
                         name: "campaign_donation_stats_count_nonnegative"
  end
end
