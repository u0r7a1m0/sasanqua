class Frequency < ApplicationRecord
  belongs_to :routine
  validates :frequency, presence: true
  enum frequency:{
    oneday_once:  0, #1日に1回
    oneday_twice: 1, #1日に2回
    oneday_third: 2, #1日に3回
    twoday_once: 3, #2日に1回
    threeday_once: 4 #3日に1回
  }
end
