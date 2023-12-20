class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :surname
      t.string :password_digest
      t.integer :role, default: 0
      t.string :email
      t.string :city
      t.string :phone_number
      t.datetime :celebration_date

      t.timestamps
    end
  end
end
