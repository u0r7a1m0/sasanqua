class Task < ApplicationRecord
  belongs_to :routine
  validates :main_task, presence: true
end
