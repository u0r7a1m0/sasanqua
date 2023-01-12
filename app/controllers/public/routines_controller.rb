class Public::RoutinesController < ApplicationController


  def new
    @routine = Routine.new
    @routine.tasks.build
    @routine.implementation_times.build
    @routine.frequencies.build
    @routine.periods.build

  end

  def create
    @routine = Routine.new(routine_params)
    @routine.customer_id = current_customer.id
    # binding.pry
    if @routine.save
    # 投稿成功した場合
    flash[:notice]="登録完了しました！"
    redirect_to my_page_path
    else
    # 投稿が失敗した場合
    # @routine = Routine.new
    redirect_to new_routine_path
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
  # def routine_params
  #   params.require(:routine).permit(:target, :routine_image, :public_status, :customer_id)
  # end
  # def task_params
  #   params.require(:task).permit(:routine_id, :main_task, :sub_task)
  # end
  # def implementation_time_params
  #   params.require(:implementation_time).permit(:accurate_time, :approximate_time, :routine_id)
  # end
  # def frequencie_params
  #   params.require(:frequencie).permit(:routine_id, :frequency)
  # end
  # def priod
  #   params.require(:frequencie).permit(:routine_id, :period)
  # end
  # 複数モデル紐付けのパラムス
  def routine_params
    params.require(:routine).permit(:target, :routine_image, :public_status, :customer_id,
                                    tasks_attributes: [:routine_id, :main_task, :sub_task],
                                    implementation_times_attributes: [:accurate_time, :approximate_time, :routine_id],
                                    frequencies_attributes: [:routine_id, :frequency],
                                    periods_attributes: [:routine_id, :period]
                                    )
  end


  def customer_params
    params.require(:customer).permit(:customer_id, :nickname, :is_deleted, :created_at, :updated_at)
  end
end
