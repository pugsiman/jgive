class AddDonorNameToDonations < ActiveRecord::Migration[8.0]
  def change
    change_table :donations, bulk: true do |t|
      t.string :donor_first_name
      t.string :donor_last_name
    end
  end
end
