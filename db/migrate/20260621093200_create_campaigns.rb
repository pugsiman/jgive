class CreateCampaigns < ActiveRecord::Migration[8.0]
  def change
    create_table :campaigns do |t|
      t.string :title, null: false
      t.text :story, null: false
      t.bigint :goal_amount_cents, null: false

      t.timestamps
    end

    add_check_constraint :campaigns, "goal_amount_cents > 0", name: "campaigns_goal_amount_cents_positive"
  end
end
