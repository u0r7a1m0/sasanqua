class Task < ApplicationRecord
  belongs_to :routine
  has_many :sub_tasks
  has_many :task_commits
  # has_many :sub_task_commits, through: :sub_tasks
  validates :name, {length:{maximum:18} }
  validates :name, presence: true
  accepts_nested_attributes_for :sub_tasks, allow_destroy: true, update_only: true, reject_if: :all_blank
  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["routine", "sub_tasks", "task_commits"]
  end
end
