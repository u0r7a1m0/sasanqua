class Public::RoutinesController < ApplicationController
  before_action :authenticate_customer!

  def new
    @routine = Routine.new
    @routine.build_task
    @routine.task.sub_tasks.build
    @routine.task.sub_tasks.build
    
    @routine.build_implementation_time
    @routine.build_frequency
    @routine.build_period
  end

  def create
    @routine = Routine.new(routine_params)
    
    # きっちり/ざっくり時間の判定
    if @routine.implementation_time.implementation_time_radio == 'accurate_time'
      @routine.implementation_time.approximate_time = nil # きっちり時間の場合approximate_timeがnilになる
    else
      @routine.implementation_time.accurate_time = nil # ざっくり時間の場合accurate_timeがnilになる
    end
    
    @routine.customer_id = current_customer.id
    if @routine.save
      # 投稿成功した場合
      flash[:notice]="登録完了しました！"
      redirect_to my_page_path
    else
      case @routine.task.sub_tasks.size
      when 0 then
        @routine.task.sub_tasks.build
        @routine.task.sub_tasks.build
      when 1 then
        @routine.task.sub_tasks.build
      else
      end
      # 投稿が失敗した場合
      render "new"
    end
  end

  def index
    @q = Routine.ransack(params[:q])
    @routines = @q.result.where(public_status:true).order("created_at DESC").all
    @current_routines_array = []
    @current_routines = []
    @backnumber_routines_array = []
    @backnumber_routines = []
    current_daytime = Time.current
    @routines.each do |routine|
      # created_at + period <=> current_day
      if routine.created_at.since(Period::TASK_DURATION_TABLE[routine.period.period.to_sym]).after?(current_daytime)
        @current_routines_array << routine
      end
      unless routine.created_at.since(Period::TASK_DURATION_TABLE[routine.period.period.to_sym]).after?(current_daytime)
        @backnumber_routines_array << routine
      else
        @backnumber_routines = Kaminari.paginate_array(@backnumber_routines_array).page(params[:page])
      end
    end
        @current_routines = Kaminari.paginate_array(@current_routines_array).page(params[:page])
        @backnumber_routines = Kaminari.paginate_array(@backnumber_routines_array).page(params[:page])
  end

  def show
    @routine = Routine.find(params[:id])
    @today =  Date.today.to_datetime + Rational("5/24")
    set_loop_count
    set_offset_date
  end
  
  def heatmap
    routine_id = params["routine_id"]
    routine = Routine.find(routine_id)
    heat_map = Hash.new
    if routine.task.sub_tasks.present?
    #   # sub task
        today = Time.current.beginning_of_day
        (today.ago(4.month).to_date..today.to_date).map do |date| 
          time = Time.parse(date.to_s).to_i
          sub_tasks = routine.task.sub_tasks
          sub_task_commits = SubTaskCommit.where(sub_task_id: sub_tasks.ids)
          if sub_task_commits.present?
            top = sub_task_commits.where(created_at: (date.beginning_of_day)..(date.end_of_day)).count
          else
            top = 0
          end
            if routine.frequency.frequency == "oneday_twice"
              bottom = routine.task.sub_tasks.count * 2
            elsif routine.frequency.frequency == "oneday_third"
              bottom = routine.task.sub_tasks.count * 3
            else
              bottom = routine.task.sub_tasks.count
            end
          score = (top/bottom.to_f * 100).ceil
          if score > 0
            heat_map.merge!(time => score)
          end
        end
    else
      today = Time.current.beginning_of_day
      (today.ago(4.month).to_date..today.to_date).map do |date| 
        time = Time.parse(date.to_s).to_i
        if routine.frequency.frequency == "oneday_twice"
          score = routine.task.task_commits.where(created_at: (date.beginning_of_day)..(date.end_of_day)).count * 50
        elsif routine.frequency.frequency == "oneday_third"
          score = routine.task.task_commits.where(created_at: (date.beginning_of_day)..(date.end_of_day)).count * 33
          score = score + 1 if score == 99
        else
          score = routine.task.task_commits.where(created_at: (date.beginning_of_day)..(date.end_of_day)).count * 100
        end
        if score > 0
          heat_map.merge!(time => score)
        end
      end
    end
    render json: heat_map
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
  
  def destroy
    @routine = Routine.find(params[:id])
    @routine.destroy
    redirect_to my_page_path
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
                                    implementation_time_attributes: [:implementation_time_radio, :accurate_time, :approximate_time, :routine_id],
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
  
  def set_loop_count
    if @routine.frequency.frequency == "oneday_twice"
      @loop_count = 2
    elsif @routine.frequency.frequency == "oneday_third"
      @loop_count = 3
    else
      @loop_count = 1
    end
  end
  
  def set_offset_date
    if @routine.frequency.frequency == "twoday_once"
      @offset_date = 1
    elsif @routine.frequency.frequency == "threeday_once"
      @offset_date = 2
    else
      @offset_date = 0
    end
  end
end
