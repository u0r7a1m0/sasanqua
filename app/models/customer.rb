class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line] # この1行を追加

  has_one_attached :profile_image

  has_many :routines, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_routines, through: :bookmarks, source: :routine
  
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image01.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'no_image01.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end



  #LINEAPI用に追記
  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]

    access_token = credentials["refresh_token"]
    access_secret = credentials["secret"]
    credentials = credentials.to_json
    nickname = info["nickname"]
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end
  # 検索機能
  # def self.looks(search, word)
  #   if search == "perfect_match"
  #     @customer = Customer.where("name LIKE?", "#{word}")
  #   elsif search == "forward_match"
  #     @customer = Customer.where("name LIKE?","#{word}%")
  #   elsif search == "backward_match"
  #     @customer = Customer.where("name LIKE?","%#{word}")
  #   elsif search == "partial_match"
  #     @customer = Customer.where("name LIKE?","%#{word}%")
  #   else
  #     @customer = Customer.all
  #   end
  # end

end