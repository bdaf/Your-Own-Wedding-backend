class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :surname
      t.string :password_digest, null: false
      t.integer :role, default: 0
      t.string :email, null: false
      t.string :city
      t.string :phone_number
      t.datetime :celebration_date, null: false

      t.timestamps
    end
  end
end
