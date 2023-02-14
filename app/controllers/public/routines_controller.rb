class Public::RoutinesController < ApplicationController
  before_action :authenticate_customer!


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
  end

  def index
    # @customer = current_customer
    @routines = Routine.where(public_status:true).order("created_at DESC").all

    @current_routines = []
    @backnumber_routines = []
    current_daytime = Time.current
    @routines.find_each do |routine|
      # created_at + period <=> current_day
      if routine.created_at.since(Period::TASK_DURATION_TABLE[routine.period.period.to_sym]).after?(current_daytime)
        @current_routines << routine
      else
        @backnumber_routines << routine
      end
    end
  end

  def show
    @routine = Routine.find(params[:id])
    @today =  Date.today.to_datetime + Rational("5/24")
    if @routine.frequency.frequency == "oneday_twice"
      @loop_count = 2
    elsif @routine.frequency.frequency == "oneday_third"
      @loop_count = 3
    else
      @loop_count = 1
    end

    # レベルアイコン
    


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


  def redirect_root
    redirect_to root_path unless customer_signed_in?
  end
end
