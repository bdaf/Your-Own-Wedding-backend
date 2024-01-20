class CreateTaskMonths < ActiveRecord::Migration[7.1]
  def change
    create_table :task_months do |t|
      t.references :organizer, null: false, foreign_key: true
      t.integer :month_number, null: false
      t.integer :year, null: false

      t.timestamps
    end
  end
end
