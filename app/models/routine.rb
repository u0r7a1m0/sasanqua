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

  # レベルアイコン
  def level
    if frequency.frequency == "twoday_once" #2日に1回
      if task.sub_tasks.present?
        task_count = task.sub_tasks.count
        total = (Period::DAY_COUNT_TABLE[period.period.to_sym]/2)*task_count
        commit_count = task.sub_tasks.map{|t| t.sub_task_commits.count}.sum
        num = (commit_count.to_f/total.to_f)
          if !num.zero?
            (num*100).ceil(-1).digits[1]
          else
            1
          end
      else
        task_count = task.count
        total = (Period::DAY_COUNT_TABLE[period.period.to_sym]/2)*task_count
        commit_count = task.map{|t| t.task_commits.count}.sum
        num = (commit_count.to_f/total.to_f)
          if !num.zero?
            (num*100).ceil(-1).digits[1]
          else
            1
          end
      end
    elsif frequency.frequency == "threeday_once" #3日に1回
      if sub_task.present?
        task_count = task.sub_tasks.count
        total = (Period::DAY_COUNT_TABLE[period.period.to_sym]/3)*task_count
        commit_count = task.sub_tasks.map{|t| t.sub_task_commits.count}.sum
        num = (commit_count.to_f/total.to_f)
          if !num.zero?
            (num*100).ceil(-1).digits[1]
          else
            1
          end
      else
        task_count = task.count
        total = (Period::DAY_COUNT_TABLE[period.period.to_sym]/3)*task_count
        commit_count = task.map{|t| t.task_commits.count}.sum
        num = (commit_count.to_f/total.to_f)
          if !num.zero?
            (num*100).ceil(-1).digits[1]
          else
            1
          end
      end
    elsif frequency.frequency == "oneday_third" #1日に3回
      if sub_task.present?
        task_count = task.sub_tasks.count
        total = (Period::DAY_COUNT_TABLE[period.period.to_sym]*3)*task_count
        commit_count = task.sub_tasks.map{|t| t.sub_task_commits.count}.sum
        num = (commit_count.to_f/total.to_f)
          if !num.zero?
            (num*100).ceil(-1).digits[1]
          else
            1
          end
      else
        task_count = task.count
        total = (Period::DAY_COUNT_TABLE[period.period.to_sym]*3)*task_count
        commit_count = task.map{|t| t.task_commits.count}.sum
        num = (commit_count.to_f/total.to_f)
          if !num.zero?
            (num*100).ceil(-1).digits[1]
          else
            1
          end
      end


    elsif frequency.frequency == "oneday_twice" #1日に2回
      if task.sub_tasks.present?
        task_count = task.sub_tasks.count
        total = (Period::DAY_COUNT_TABLE[period.period.to_sym]*2)*task_count
        commit_count = task.sub_tasks.map{|t| t.sub_task_commits.count}.sum
        num = (commit_count.to_f/total.to_f)
          if !num.zero?
            (num*100).ceil(-1).digits[1]
          else
            1
          end
      else
        task_count = task.count
        total = (Period::DAY_COUNT_TABLE[period.period.to_sym]*2)*task_count
        commit_count = task.map{|t| t.task_commits.count}.sum
        num = (commit_count.to_f/total.to_f)
          if !num.zero?
            (num*100).ceil(-1).digits[1]
          else
            1
          end
      end

    else
      if task.sub_tasks.present?
        task_count = task.sub_tasks.count
        total = (Period::DAY_COUNT_TABLE[period.period.to_sym])*task_count
        commit_count = task.sub_tasks.map{|t| t.sub_task_commits.count}.sum
        num = (commit_count.to_f/total.to_f)
          if !num.zero?
            (num*100).ceil(-1).digits[1]
          else
            1
          end
      else
        task_count = task.count
        total = (Period::DAY_COUNT_TABLE[period.period.to_sym])*task_count
        commit_count = task.map{|t| t.task_commits.count}.sum
        num = (commit_count.to_f/total.to_f)
          if !num.zero?
            (num*100).ceil(-1).digits[1]
          else
            1
          end
      end
    end
  end
end
