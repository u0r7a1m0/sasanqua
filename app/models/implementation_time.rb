class ImplementationTime < ApplicationRecord
  attribute :implementation_time_radio # かっちり/ざっくりラジオボタンの仮想カラム
  belongs_to :routine
end