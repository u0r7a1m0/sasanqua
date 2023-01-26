class Frequency < ApplicationRecord
  before_save :set_default_time
  belongs_to :routine
  has_many :task_commits
  has_many :sub_task_commits
  validates :frequency, presence: true
  enum frequency:{
    oneday_once:  0, #1日に1回
    oneday_twice: 1, #1日に2回
    oneday_third: 2, #1日に3回
    twoday_once: 3, #2日に1回
    threeday_once: 4 #3日に1回
  }

  private

  def set_default_time
    # self.reset_time ||= Time.zone.now.beginning_of_day.since(5.hours)
    self.reset_time ||= '5:00'
  end
end
