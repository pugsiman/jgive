class CreateDonations < ActiveRecord::Migration[8.0]
  def change
    create_enum :donation_state, %w[pending paid]

    create_table :donations do |t|
      t.references :campaign, null: false, foreign_key: true
      t.bigint :amount_cents, null: false
      t.string :giving_frequency, null: false, default: "one_time"
      t.string :donor_display_preference, null: false, default: "full_name"
      t.text :dedication_message
      t.string :user_email, null: false
      t.enum :state, enum_type: "donation_state", null: false, default: "pending"

      t.timestamps
    end

    add_index :donations, %i[campaign_id state]
    add_index :donations, %i[campaign_id user_email]
    add_index :donations, "lower(user_email)", name: "index_donations_on_lower_user_email"

    add_check_constraint :donations, "amount_cents > 0", name: "donations_amount_cents_positive"
    add_check_constraint :donations, "giving_frequency in ('one_time', 'recurring')",
                         name: "donations_giving_frequency_valid"
    add_check_constraint :donations, "donor_display_preference in ('full_name', 'first_name_only', 'anonymous')",
                         name: "donations_donor_display_preference_valid"
  end
end
