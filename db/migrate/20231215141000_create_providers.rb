class CreateProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :providers do |t|
      t.string :phone_number
      t.string :address

      t.belongs_to :user, index: { unique: true }, foreign_key: true
    end
  end
end
