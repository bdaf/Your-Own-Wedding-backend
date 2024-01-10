class CreateNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :notes do |t|
      t.references :event, null: false, foreign_key: true
      t.string :name
      t.text :body

      t.timestamps
    end
  end
end
