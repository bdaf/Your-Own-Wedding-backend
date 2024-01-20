class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :surname
      t.string :password_digest, null: false
      t.integer :role, default: 0, null: false
      t.string :email, null: false

      t.timestamps
    end
  end
end
