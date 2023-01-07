class Public::RoutinesController < ApplicationController


  def new
    @routine = Routine.new

  end

  def create
    @routine = Routine.new(routine_params)
      # binding.pry
    if @routine.save
    # 投稿成功した場合
    flash[:notice]="登録完了しました！"
    redirect_to my_page_path
    else
    # 投稿が失敗した場合
    @routine = Routine.new
    render :new
    end
  end

  def index
    @routines = Routine.all
    # @routines = Routine.all.page(params[:page]).per(10)
  end

  def show
    @routine = Routine.find(params[:id])

  end

  def edit
    @routine = Routine.find(params[:id])
  end

  def update
    @routine = Routine.find(params[:id])
    if @routine.update(item_params)
    # 更新に成功したときの処理
      flash[:notice]="更新完了しました！"
      redirect_to routine_path(@routine.id)
    else
      render :edit
    end
  end

  private
  def routine_params
    params.require(:routine).permit(:target, :routine_image, :public_status, :customer_id)
  end
  def task_params
    params.require(:task).permit(:routine_id, :main_task, :sub_task)
  end
  def implementation_time_params
    params.require(:implementation_time).permit(:accurate_time, :approximate_time, :routine_id)
  end
  def routine_params
    params.require(:frequencie).permit(:routine_id, :frequencie)
  end

end
