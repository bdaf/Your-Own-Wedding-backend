class AddCategoryToOffer < ActiveRecord::Migration[7.1]
  def change
    add_column :offers, :category, :integer, null: false, default: 0
  end
end
