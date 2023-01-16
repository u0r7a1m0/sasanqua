class Task < ApplicationRecord
  belongs_to :routine
  has_many :sub_tasks
  validates :name, presence: true
  accepts_nested_attributes_for :sub_tasks, allow_destroy: true, update_only: true, reject_if: :all_blank
end
