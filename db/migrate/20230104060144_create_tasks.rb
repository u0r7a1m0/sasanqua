class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|

      t.string :main_task,            null: false, default: ""
      t.string :sub_task

      t.timestamps
    end
  end
end
