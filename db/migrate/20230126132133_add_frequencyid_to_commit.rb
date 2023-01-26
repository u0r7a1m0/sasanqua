class AddFrequencyidToCommit < ActiveRecord::Migration[6.1]
  def change
    add_reference :task_commits, :frequency
    add_reference :sub_task_commits, :frequency
  end
end
