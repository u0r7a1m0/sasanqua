class Public::TaskCommitsController < ApplicationController
  def create
    @routine = Routine.find(params[:routine_id])
    today = Date.today.to_datetime + Rational("5/24")
    next_day = Date.today.to_datetime + 1 + Rational("5/24")

    loop_count.times do |index|
      next if task_params["task_#{index + 1}".to_sym].to_i.zero?
      next if TaskCommit.where(task_id: @routine.task.id, created_at: today..next_day, times: index + 1).present?
      TaskCommit.create!(task: @routine.task, frequency: @routine.frequency, times: index + 1)
    end
  end

  private

  def task_params
     params.require(:task).permit(:task_1, :task_2, :task_3)
  end

  def loop_count
    if @routine.frequency.frequency == "oneday_twice"
      count = 2
    elsif @routine.frequency.frequency == "oneday_third"
      count = 3
    else
      count = 1
    end
    count
  end
end
