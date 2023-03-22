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

  validates :target, {length:{maximum:20} }
  validates :target, presence: true
  validate :time_radio_select # きっちり/ざっくり時間設定のバリデーション
  # きっちり/ざっくり時間設定のバリデーション
  #   ラジオボタンの状態で入力値が正しく入力されているかのバリデーション
  #   TODO: implementation_timeで仮想カラムを指定している。
  def time_radio_select
    case self.implementation_time.implementation_time_radio
    when 'accurate_time' then # 時刻を設定
      errors.add(:accurate_time, 'が設定されていません。') if self.implementation_time.accurate_time.blank?
    when 'approximate_time' then # ざっくり時間
      errors.add(:approximate_time, 'が設定されていません。') if self.implementation_time.approximate_time.blank?
    end
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["bookmarks", "customer", "frequency", "implementation_time", "level_icon_attachment", "level_icon_blob", "period", "routine_image_attachment", "routine_image_blob", "task"]
  end
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "customer_id", "id", "public_status", "target", "updated_at"]
  end
  
  def next_day
    r = Rational("5/24")
    if frequency.frequency == "twoday_once"
      Date.today.to_datetime + 2 + r
    elsif frequency.frequency == "threeday_once"
      Date.today.to_datetime + 3 + r
    else
      Date.today.to_datetime + 1 + r
    end
  end
  
  def before_frequency_range
    # 最初のcommiの範囲であればcreated_atからのrangeを返す
    
    start_at = correct_range_start_at(created_at)
    return start_at..start_at.since(frequency_day) if first_commit_range?

    # 今日からcorrect_frequencyを引いたものを範囲の始まりにする
    
    target_time = correct_range_start_at(Time.zone.now)
    if Time.zone.now.hour < 5
       condition_start_at = target_time.ago(correct_frequency.day) - 1.day
    else
      condition_start_at = target_time.ago(correct_frequency.day)
    end
    condition_end_at = condition_start_at + frequency_day
   # binding.pry
    #2:00にタスクじっこう
    condition_start_at..condition_end_at
  end
  
  # 今日から作成日を引いた日数の余り
  def correct_frequency
    base = correct_range_start_at(created_at)
    if frequency.frequency == "twoday_once"
      ((Time.zone.now.to_date - base.to_date) % 2).to_i
    elsif frequency.frequency == "threeday_once"
      ((Time.zone.now.to_date - base.to_date) % 3).to_i
    else
      0
    end
  end
  
  # commitの最初のチェック範囲かどうかを確認する
  def first_commit_range?
    day_diff = (Time.zone.now.beginning_of_day.since(5.hour).to_date - correct_range_start_at(created_at).to_date).to_i
    if frequency.frequency == "twoday_once"
      day_diff < 2
    elsif frequency.frequency == "threeday_once"
      day_diff < 3
    else
      day_diff < 1
    end
  end
  
  def frequency_day
    if frequency.frequency == "twoday_once"
      2.day
    elsif frequency.frequency == "threeday_once"
      3.day
    else
      1.day
    end
  end
  
  # 5時よりも前であれば前日の5時を始まりにする,そうでなければ当日の5時を始まりにする
  def correct_range_start_at(start_at)
    start_at.hour < 5 ? start_at.beginning_of_day.ago(1).since(5.hour) : start_at.beginning_of_day.since(5.hour)
  end

  def bookmarked_by?(customer)
    bookmarks.where(customer_id: customer).exists?
  end

  # レベルアイコン
  def level
    if period.period == "one_year" or period.period == "everyday"
      if frequency.frequency == "twoday_once" #2日に1回
      # byebug
        if task.sub_tasks.present?
          task_count = task.sub_tasks.count
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]/2)*task_count
          commit_count = task.sub_tasks.map{|t| t.sub_task_commits.where("created_at BETWEEN ? AND ?", Time.current.beginning_of_month, Time.current.end_of_month).count}.sum

        else
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]/2)*1
          commit_count = task.task_commits.where("created_at BETWEEN ? AND ?", Time.current.beginning_of_month, Time.current.end_of_month).count
        end
      elsif frequency.frequency == "threeday_once" #3日に1回
        if task.sub_tasks.present?
          task_count = task.sub_tasks.count
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]/3)*task_count
          commit_count = task.sub_tasks.map{|t| t.sub_task_commits.where("created_at BETWEEN ? AND ?", Time.current.beginning_of_month, Time.current.end_of_month).count}.sum
        else
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]/3)*1
          commit_count = task.task_commits.where("created_at BETWEEN ? AND ?", Time.current.beginning_of_month, Time.current.end_of_month).count
        end
      elsif frequency.frequency == "oneday_third" #1日に3回
        if task.sub_tasks.present?
          task_count = task.sub_tasks.count
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]*3)*task_count
          commit_count = task.sub_tasks.map{|t| t.sub_task_commits.where("created_at BETWEEN ? AND ?", Time.current.beginning_of_month, Time.current.end_of_month).count}.sum
        else
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]*3)*1
          commit_count = task.task_commits.where("created_at BETWEEN ? AND ?", Time.current.beginning_of_month, Time.current.end_of_month).count
        end
      elsif frequency.frequency == "oneday_twice" #1日に2回
        if task.sub_tasks.present?
          task_count = task.sub_tasks.count
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]*2)*task_count
          commit_count = task.sub_tasks.map{|t| t.sub_task_commits.where("created_at BETWEEN ? AND ?", Time.current.beginning_of_month, Time.current.end_of_month).count}.sum
        else
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]*2)*1
          commit_count = task.task_commits.where("created_at BETWEEN ? AND ?", Time.current.beginning_of_month, Time.current.end_of_month).count
        end
      else  # 1日に1回
        if task.sub_tasks.present?
          task_count = task.sub_tasks.count
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym])*task_count
          commit_count = task.sub_tasks.map{|t| t.sub_task_commits.where("created_at BETWEEN ? AND ?", Time.current.beginning_of_month, Time.current.end_of_month).count}.sum
        else
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym])*1
          commit_count = task.task_commits.where("created_at BETWEEN ? AND ?", Time.current.beginning_of_month, Time.current.end_of_month).count
        end
      end
    else
      if frequency.frequency == "twoday_once" #2日に1回
        if task.sub_tasks.present?
          task_count = task.sub_tasks.count
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]/2)*task_count
          commit_count = task.sub_tasks.map{|t| t.sub_task_commits.count}.sum
        else
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]/2)*1
          commit_count = task.task_commits.count
        end
      elsif frequency.frequency == "threeday_once" #3日に1回
        if task.sub_tasks.present?
          task_count = task.sub_tasks.count
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]/3)*task_count
          commit_count = task.sub_tasks.map{|t| t.sub_task_commits.count}.sum
        else
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]/3)*1
          commit_count = task.task_commits.count
        end
      elsif frequency.frequency == "oneday_third" #1日に3回
        if task.sub_tasks.present?
          task_count = task.sub_tasks.count
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]*3)*task_count
          commit_count = task.sub_tasks.map{|t| t.sub_task_commits.count}.sum
        else
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]*3)*1
          commit_count = task.task_commits.count
        end
  
      elsif frequency.frequency == "oneday_twice" #1日に2回
        if task.sub_tasks.present?
          task_count = task.sub_tasks.count
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]*2)*task_count
          commit_count = task.sub_tasks.map{|t| t.sub_task_commits.count}.sum
        else
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym]*2)*1
          commit_count = task.task_commits.count
        end
  
      else  # 1日に1回
        if task.sub_tasks.present?
          task_count = task.sub_tasks.count
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym])*task_count
          commit_count = task.sub_tasks.map{|t| t.sub_task_commits.count}.sum
        else
          total = (Period::DAY_COUNT_TABLE[period.period.to_sym])*1
          commit_count = task.task_commits.count
        end
      end
    end

    num = (commit_count.to_f/total.to_f) * 100
    num = 100  if num > 100
    if !num.zero?
      ret = num.ceil(-1).digits[1]
      if ret == 0
        return 10
      else
        return ret
      end
    else
      1
    end
  end
  
end
