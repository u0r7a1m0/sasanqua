class CreateTaskCommits < ActiveRecord::Migration[6.1]
  def change
    create_table :task_commits do |t|
      t.integer :task_id
      t.integer :score
      t.integer :times

      t.timestamps
    end
  end
end
