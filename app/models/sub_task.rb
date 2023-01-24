class SubTask < ApplicationRecord
  belongs_to :task
  has_many :sub_task_commits
end
