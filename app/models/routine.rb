class Routine < ApplicationRecord
  has_one_attached :routine_image
  has_one_attached :level_icon

  has_one :task, dependent: :destroy
  has_one :implementation_time, dependent: :destroy
  has_one :frequency, dependent: :destroy
  has_one :period, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  belongs_to :customer
  accepts_nested_attributes_for :task, allow_destroy: true , update_only: true # fields_for（後述）に必要
  accepts_nested_attributes_for :implementation_time, allow_destroy: true, update_only: true
  accepts_nested_attributes_for :frequency, allow_destroy: true, update_only: true
  accepts_nested_attributes_for :period, allow_destroy: true, update_only: true

  def  next_day
    r = Rational("5/24")
    if frequency.frequency == "twoday_once"
      Date.today.to_datetime + 2 + r
    elsif frequency.frequency == "threeday_once"
      Date.today.to_datetime + 3 + r
    else
      Date.today.to_datetime + 1 + r
    end
  end

  def bookmarked_by?(customer)
    bookmarks.where(customer_id: customer).exists?
  end
  def short_description
    description[0, 9] + '...'
  end

end
