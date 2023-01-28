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
      today_sub_task_commits = SubTaskCommit.where(created_at: today..next_day, times: 1)
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
      not_exist_sub_task_ids.each do |sub_task_id|
        SubTaskCommit.create(sub_task_id: sub_task_id, times: 1)
      end
     end

    if sub_task_2.present?
      today = Date.today.to_datetime + Rational("5/24")
      next_day = Date.today.to_datetime + 1 + Rational("5/24")
      today_sub_task_commits = SubTaskCommit.where(created_at: today..next_day, times: 2)
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
      today_sub_task_commits = SubTaskCommit.where(created_at: today..next_day, times: 3)
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


    # if @routine.task.sub_tasks.present?
    #   #if ②.create_atが今日（翌日5:00）かどうか
    #   if Date.today == @routine.task.sub_task.create_at.to_date


    #     sub_task_1 = params[:sub_task_1][:SubTask] if params[:sub_task_1].present?
    #     sub_task_2 = params[:sub_task_2][:SubTask] if params[:sub_task_2].present?
    #     sub_task_3 = params[:sub_task_3][:SubTask] if params[:sub_task_3].present?
    #     #if　③.「sub_task_2」が存在するなら

    #       #if　3-2.「sub_task_3」が存在する場合は以下実行（1日3回の人）（commit1& 3& 2）
    #         # DBから「sub_task_commit」データを持ってきて、全部をうわがきする
    #         commit1 = SubTaskCommit.find_by(times: 1)
    #         commit1.sub_task_id.nil? ? commit1.destroy : commit1.save

    #         commit2 = SubTaskCommit.find_by(times: 2)
    #         commit2.sub_task_id.nil? ? commit2.destroy : commit2.save

    #         commit3 = SubTaskCommit.find_by(times: 3)
    #         commit3.sub_task_id.nil? ? commit3.destroy : commit1.save

    #         # commit2 = SubTaskCommit.new if commmit2.nil?
    #         # commit2.sub_task_id = params[:sub_task_id]
    #       #end
    #       # 3がないなら以下実行（1日2回の人）（commit1&2）
    #       commit1 = SubTaskCommit.find_by(times: 1)
    #       commit1.sub_task_id.nil? ? commit1.destroy : commit1.save

    #       commit2 = SubTaskCommit.find_by(times: 2)
    #       commit2.sub_task_id.nil? ? commit2.destroy : commit2.save

    #     else　#3-3.その他全部（commit1）
    #       #saveする
    #       commit1 = SubTaskCommit.find_by(times: 1)
    #       commit1.sub_task_id.nil? ? commit1.destroy : commit1.save

    #     #3-3.その他全部（データが存在してないから、creatしてあげる
    #     end


    # else　#チェックがなかった場合
    #   redirect_to routine_path(@routine.id)
    # end

    redirect_to routine_path(@routine.id)

  end
   ####################

    # 完了しているものをレコードとしてSubTaskCommitに保存する
    # RoutingのShowにredirect_to




  def destroy

  end


  private
  def sub_task_params
    params.require(:sub_task).permit(:task_id)
  end
end
