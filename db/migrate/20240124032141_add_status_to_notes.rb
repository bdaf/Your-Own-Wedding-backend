class AddStatusToNotes < ActiveRecord::Migration[7.1]
  def change
    add_column :notes, :status, :integer, null: false, default: 0
  end
end
