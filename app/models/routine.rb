class Routine < ApplicationRecord
  has_one_attached :routine_image

  has_many :tasks, dependent: :destroy
  has_many :implementation_times, dependent: :destroy
  has_many :frequencies, dependent: :destroy
  has_many :periods, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  belongs_to :customer
  accepts_nested_attributes_for :tasks, allow_destroy: true  # fields_for（後述）に必要
  accepts_nested_attributes_for :implementation_times, allow_destroy: true
  accepts_nested_attributes_for :frequencies, allow_destroy: true
  accepts_nested_attributes_for :periods, allow_destroy: true




  # def get_routine_image(width, height)
  #   unless item_image.attached?
  #     file_path = Rails.root.join('app/assets/images/no_image.jpg')
  #     routine_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpg')
  #   end
  #   routine_image.variant(resize_to_limit: [width, height]).processed
  # end
end
