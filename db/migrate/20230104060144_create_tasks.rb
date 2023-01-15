class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.integer :routine_id
      t.string :name,            null: false, default: ""

      t.timestamps
    end
  end
end
