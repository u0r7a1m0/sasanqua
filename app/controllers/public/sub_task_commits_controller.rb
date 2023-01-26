class Public::SubTaskCommitsController < ApplicationController
  def create
    @routine = Routine.find(params[:routine_id])

    # チェックされたデータがあるかどうか
    if @routine.task.sub_task.id.present?
      redirect_to routine_path(@routine.id)
    else
      render :show
    end
    # 完了しているものをレコードとしてSubTaskCommitに保存する
    # RoutingのShowにredirect_to
  end
  
  
  
  def destroy
    
  end
end
