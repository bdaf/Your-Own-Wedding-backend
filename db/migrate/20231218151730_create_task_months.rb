class CreateTaskMonths < ActiveRecord::Migration[7.1]
  def change
    create_table :task_months do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :month_number
      t.integer :year

      t.timestamps
    end
  end
end
