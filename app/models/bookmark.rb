class Bookmark < ApplicationRecord
  belongs_to :customer
  belongs_to :routine
end
