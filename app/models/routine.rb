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

  def level
    # 9
    # byebug

    if frequency.frequency == "twoday_once"
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
    # 　else
        # d = task.count
        # n= task.task_commits.count/(Period::DAY_COUNT_TABLE[period.period.to_sym]/2)*d
        # n*100.ceil.digits[1]
      end
    end
  #   elsif　@routine.frequency.frequency == "threeday_once"
  #   　if sub_task.present?
  #   　　d = @routine.task.sub_task.count
  #   　　n= {(Period: :DAY_COUNT_TABELE/3)*d}/@routine.task.sub_task.sub_task_commits.count
  #   　　s = n*100
  #   　else
  #   　　d = @routine.task.count
  #   　　n= {(Period: :DAY_COUNT_TABELE/3)*d}/@routine.task.task_commits.count
  #   　　s = n*100
  #   else　それ以外(1~3)
  #   　if sub_task.present?
  #       d = @routine.task.sub_task.count
  #       n= (Period: :DAY_COUNT_TABELE*d)/@routine.task.sub_task.sub_task_commits.count
  #       s = n*100
  #   　else
  #       d = @routine.task.count
  #       n= (Period: :DAY_COUNT_TABELE*d)/@routine.task.task_commits.count
  #       s = n*100
  #   end
  end

end
