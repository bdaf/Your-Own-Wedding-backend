class AddAdditionContactDataToOffers < ActiveRecord::Migration[7.1]
  def change
    add_column :offers, :addition_contact_data, :text, null: true
  end
end
