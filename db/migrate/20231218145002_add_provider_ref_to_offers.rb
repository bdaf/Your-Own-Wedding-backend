class AddProviderRefToOffers < ActiveRecord::Migration[7.1]
  def change
    add_reference :offers, :provider, null: false, foreign_key: true
  end
end
