class CreateAdditionAttribiutes < ActiveRecord::Migration[7.1]
  def change
    create_table :addition_attribiutes do |t|
      t.references :guest, null: false, foreign_key: true
      t.string :name
      t.text :value

      t.timestamps
    end
  end
end
