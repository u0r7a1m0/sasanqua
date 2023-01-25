class CreateSubTaskCommits < ActiveRecord::Migration[6.1]
  def change
    create_table :sub_task_commits do |t|
      t.integer :sub_task_id
      t.integer :score
      t.integer :times

      t.timestamps
    end
  end
end
