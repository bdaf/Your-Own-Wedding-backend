class CreateOffers < ActiveRecord::Migration[7.1]
  def change
    create_table :offers do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :address, null: false

      t.timestamps
    end
  end
end
