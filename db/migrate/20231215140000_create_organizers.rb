class CreateOrganizers < ActiveRecord::Migration[7.1]
  def change
    create_table :organizers do |t|
      t.datetime :celebration_date, :null => false

      t.belongs_to :user, index: { unique: true }, foreign_key: true
    end
  end
end
