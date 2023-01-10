class Period < ApplicationRecord
  belongs_to :routine
  validates :period, presence: true
end
