class AddUniqueIndexToAdditionAttribiutes < ActiveRecord::Migration[7.1]
  def change
    add_index :addition_attribiutes, [:addition_attribiute_name_id, :guest_id], unique: true
  end
end
