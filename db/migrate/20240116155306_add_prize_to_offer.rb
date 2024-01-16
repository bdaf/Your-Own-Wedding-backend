class AddPrizeToOffer < ActiveRecord::Migration[7.1]
  def change
    add_column :offers, :prize, :float, null: false, default: 0
    #Ex:- :null => false
  end
end
