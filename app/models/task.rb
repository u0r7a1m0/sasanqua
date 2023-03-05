class Task < ApplicationRecord
  belongs_to :routine
  has_many :sub_tasks
  has_many :task_commits
  # has_many :sub_task_commits, through: :sub_tasks
  validates :name, {length:{maximum:18} }
  validates :name, presence: true
  
  validate :sub_task_limit # サブタスクのバリデーション
  
  accepts_nested_attributes_for :sub_tasks, allow_destroy: true, update_only: true, reject_if: :all_blank
  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["routine", "sub_tasks", "task_commits"]
  end
  
  # サブタスクのバリデーション
  #   1文字以上の項目があれば2つは最低サブタスクがないとエラーを出す
  def sub_task_limit
    self.sub_tasks.each do |sub_task|
      if sub_task.name.length >= 1 && self.sub_tasks.size < 2
        errors.add(:sub_task_rule, "は、2つ以上必須です。")
      end
    end
  end
end
