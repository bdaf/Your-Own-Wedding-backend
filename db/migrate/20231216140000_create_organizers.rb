class CreateOrganizers < ActiveRecord::Migration[7.1]
  def change
    create_table :organizers do |t|
      t.datetime :celebration_date, :null => false

      t.references :user, null: false, foreign_key: true
    end
  end
end
