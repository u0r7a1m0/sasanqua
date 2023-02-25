class SubTask < ApplicationRecord
  belongs_to :task
  has_many :sub_task_commits
  validates :name, {length:{maximum:15} }
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "task_id", "updated_at"]
  end
end
