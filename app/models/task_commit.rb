class TaskCommit < ApplicationRecord
  belongs_to :task
  belongs_to :frequency
end
