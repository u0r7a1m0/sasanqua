class Task < ApplicationRecord
  belongs_to :routine
  has_many :sub_tasks
  validates :name, presence: true
end
