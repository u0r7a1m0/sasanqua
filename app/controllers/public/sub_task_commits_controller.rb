class Public::SubTaskCommitsController < ApplicationController
  def create
    sub_task_1 = params[:sub_task_1][:SubTask] if params[:sub_task_1].present?
    sub_task_2 = params[:sub_task_2][:SubTask] if params[:sub_task_2].present?
    sub_task_3 = params[:sub_task_3][:SubTask] if params[:sub_task_3].present?
    sub_task_1.delete("") if params[:sub_task_1].present?
    sub_task_2.delete("") if params[:sub_task_2].present?
    sub_task_3.delete("") if params[:sub_task_3].present?

    @routine = Routine.find(params[:routine_id])

    if sub_task_1.blank? && sub_task_2.blank? && sub_task_3.blank?
      redirect_to routine_path(@routine.id)
      return
    end

    #今チェックしている項目があるかどうか
    # ない -> 元の画面にもどる

    # 頻度毎に分けて確認
    #    ->  今日のコミット(SubTaskCommit)としてクリエイトされているかどうか
    #         ある ->
    #             更にチェックされている -> なにもしない
    #             更にチェックされていないもの -> コミットを削除する  // いったん保留
    #         ない -> サブタスクコミットをクリエイトをする SubTaskCommit.create()

    ####################
    # @routine.task.sub_tasks.sub_task_commit = SubTaskCommit.new(routine_params)
    #if　①.チェックされたデータがあるかどうか

    if sub_task_1.present?
      today = Date.today.to_datetime + Rational("5/24")
      next_day = Date.today.to_datetime + 1 + Rational("5/24")
      ## TODO: sub_task_idを指定する,　このままだと他のサブタスクのcommitも参照してしまう
      today_sub_task_commits = SubTaskCommit.where(sub_task_id: sub_task_1, created_at: today..next_day, times: 1)
      # 今日のコミット(SubTaskCommit)としてクリエイトされていて、且つチェックされているかの分岐
      today_sub_task_commits.each do |commit|
        if sub_task_1.include?(commit.sub_task_id)
          # なにもしない
        else
          # コミット削除
        end
      end

      # 今日のコミット(SubTaskCommit)としてクリエイトされていないものを新規作成
      sub_task_1_i = []
      sub_task_1.each do |sub_task_id|
        sub_task_1_i.push(sub_task_id.to_i)
      end
      
      not_exist_sub_task_ids = sub_task_1_i - today_sub_task_commits.pluck(:sub_task_id)
      # binding.pry
      
      not_exist_sub_task_ids.each do |sub_task_id|
        SubTaskCommit.create(sub_task_id: sub_task_id, times: 1)
      end
    end

    if sub_task_2.present?
      today = Date.today.to_datetime + Rational("5/24")
      next_day = Date.today.to_datetime + 1 + Rational("5/24")
      today_sub_task_commits = SubTaskCommit.where(sub_task_id: sub_task_2, created_at: today..next_day, times: 2)
      # 今日のコミット(SubTaskCommit)としてクリエイトされていて、且つチェックされているかの分岐
      today_sub_task_commits.each do |commit|
        if sub_task_2.include?(commit.sub_task_id)
          # なにもしない
        else
          # コミット削除
        end
      end

      # 今日のコミット(SubTaskCommit)としてクリエイトされていないものを新規作成
      sub_task_2_i = []
      sub_task_2.each do |sub_task_id|
        sub_task_2_i.push(sub_task_id.to_i)
      end
      not_exist_sub_task_ids = sub_task_2_i - today_sub_task_commits.pluck(:sub_task_id)
      not_exist_sub_task_ids.each do |sub_task_id|
        SubTaskCommit.create(sub_task_id: sub_task_id, times: 2)
      end
    end

    if sub_task_3.present?
      today = Date.today.to_datetime + Rational("5/24")
      next_day = Date.today.to_datetime + 1 + Rational("5/24")
      today_sub_task_commits = SubTaskCommit.where(sub_task_id: sub_task_3, created_at: today..next_day, times: 3)
      # 今日のコミット(SubTaskCommit)としてクリエイトされていて、且つチェックされているかの分岐
      today_sub_task_commits.each do |commit|
        if sub_task_3.include?(commit.sub_task_id)
          # なにもしない
        else
          # コミット削除
        end
      end

      # 今日のコミット(SubTaskCommit)としてクリエイトされていないものを新規作成
      sub_task_3_i = []
      sub_task_3.each do |sub_task_id|
        sub_task_3_i.push(sub_task_id.to_i)
      end
      not_exist_sub_task_ids = sub_task_3_i - today_sub_task_commits.pluck(:sub_task_id)
      not_exist_sub_task_ids.each do |sub_task_id|
        SubTaskCommit.create(sub_task_id: sub_task_id, times: 3)

      end
    end

    redirect_to routine_path(@routine.id)
  end

  private
  def sub_task_params
    params.require(:sub_task).permit(:task_id)
  end
end
