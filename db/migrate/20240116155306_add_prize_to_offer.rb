class AddPrizeToOffer < ActiveRecord::Migration[7.1]
  def change
    add_column :offers, :prize, :float, null: false
    #Ex:- :null => false
  end
end
