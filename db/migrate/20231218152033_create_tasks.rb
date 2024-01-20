class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.references :task_month, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :status, null: false, default: 0
      t.text :description

      t.timestamps
    end
  end
end
