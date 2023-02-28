class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image

  has_many :routines, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_routines, through: :bookmarks, source: :routine
  validates :nickname, {length:{maximum:10} }

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image01.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'no_image01.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

end