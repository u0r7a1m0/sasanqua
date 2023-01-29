class Routine < ApplicationRecord
  has_one_attached :routine_image

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




  # def get_routine_image(width, height)
  #   unless routine_image.attached?
  #     file_path = Rails.root.join('app/assets/images/no_image01.jpg')
  #     routine_image.attach(io: File.open(file_path), filename: 'no_image01.jpg', content_type: 'image/jpg')
  #   end
  #   routine_image.variant(resize_to_limit: [width, height]).processed
  # end


  def bookmarked_by?(customer)
    bookmarks.where(customer_id: customer).exists?
  end
  def short_description
    description[0, 9] + '...'
  end

end
