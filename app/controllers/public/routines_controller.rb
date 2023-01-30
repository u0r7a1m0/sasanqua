class Public::RoutinesController < ApplicationController

  def new
    @routine = Routine.new
    task = @routine.build_task
    task.sub_tasks.build
    @routine.build_implementation_time
    @routine.build_frequency
    @routine.build_period

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
    redirect_to new_routine_path
    end


    # DB column add day_count: 1 , 2 ,3
    #
  end

  def index
    @routines = Routine.where(public_status:true).all.order("created_at DESC").page(params[:page]).per(12)
    # @routine = Routine.find(params[:id])
  end

  def show
    @routine = Routine.find(params[:id])
  end

  def edit
    @routine = Routine.find(params[:id])
  end

  def update
    @routine = Routine.find(params[:id])

    if @routine.update(routine_params)
    # 更新に成功したときの処理
      flash[:notice]="更新完了しました！"
      redirect_to routine_path(@routine.id)
    else
      render :edit
    end

  end

  def like
    bookmarks = Bookmark.where(customer_id: current_customer.id).pluck(:routine_id)
    @routines = Routine.find(bookmarks)
    # @routines = Routine.all.order("created_at DESC").page(params[:page]).per(12)
  end

  private
  # 複数モデル紐付けのパラムス
  def routine_params
    params.require(:routine).permit(:target, :routine_image, :public_status, :customer_id,
                                    task_attributes: [:routine_id, :frequency_id, :name, sub_tasks_attributes: %i(name frequency_id _destroy) ],
                                    implementation_time_attributes: [:accurate_time, :approximate_time, :routine_id],
                                    frequency_attributes: [:routine_id, :frequency, :reset_time],
                                    period_attributes: [:routine_id, :period]
                                    )
  end

  def customer_params
    params.require(:customer).permit(:customer_id, :nickname, :is_deleted, :created_at, :updated_at)
  end

end
