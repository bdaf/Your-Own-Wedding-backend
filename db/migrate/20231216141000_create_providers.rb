class CreateProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :providers do |t|
      t.string :phone_number
      t.string :address

      t.references :user, null: false, foreign_key: true
    end
  end
end
