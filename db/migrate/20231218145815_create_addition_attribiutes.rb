class CreateAdditionAttribiutes < ActiveRecord::Migration[7.1]
  def change
    create_table :addition_attribiutes do |t|
      t.references :guest, null: false, foreign_key: true
      t.references :addition_attribiute_name, null: false, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
