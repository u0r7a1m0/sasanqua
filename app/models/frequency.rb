class Frequency < ApplicationRecord
  belongs_to :routine
  validates :frequency, presence: true
end
