class CreateGuests < ActiveRecord::Migration[7.1]
  def change
    create_table :guests do |t|
      t.references :organizer, null: false, foreign_key: true
      t.string :name
      t.string :surname

      t.timestamps
    end
  end
end
