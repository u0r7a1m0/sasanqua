class Frequencie < ApplicationRecord
  belongs_to :routine
  validates :frequencie, presence: true
end
