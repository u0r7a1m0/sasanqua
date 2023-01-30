class Period < ApplicationRecord
  belongs_to :routine
  validates :period, presence: true
  enum period:{
    everyday: 0, #ずっと続ける
    one_week: 1, #1週間
    two_week: 2, #2週間
    three_week: 3, #3週間
    four_week: 4, #4週間
    one_month: 5, #1ヶ月
    one_year: 6 #1年間
  }

  TASK_DURATION_TABLE = {everyday: 999.days, one_week: 7.days, two_week: 14.days, three_week: 21.days, four_week: 28.days, one_month: 30.days, one_year: 365.days}
end
