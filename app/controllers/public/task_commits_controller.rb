class Public::TaskCommitsController < ApplicationController
  def create
    @routine = Routine.find(params[:id])

    # チェックがないTaskのIDを検索して完了しているかチェックする
    if @routine.task.id.where()
      redirect_to routine_path(@routine.id)
    else
      render :show
    end
    # 完了しているものをレコードとしてTaskCommitに保存する
    # RoutingのShowにredirect_to
  end
end
