class CreateAdditionAttribiuteNames < ActiveRecord::Migration[7.1]
  def change
    create_table :addition_attribiute_names do |t|
      t.references :organizer, null: false, foreign_key: true
      t.string :name, null: false
      t.string :default_value

      t.timestamps
    end
  end
end
