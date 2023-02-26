class Admin::CustomersController < ApplicationController
  def index
    @customers = Customer.all.order("created_at DESC").page(params[:page]).per(8)
  end

  def show
    @customer = Customer.find(params[:id])
    @routines = @customer.routines.order("created_at DESC").page(params[:page])
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

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
    # 更新に成功したときの処理
      flash[:notice]="更新完了しました！"
      redirect_to admin_customer_path(@customer.id)
    else
      render :edit
    end
  end

  private
  def customer_params
    params.require(:customer).permit(:customer_id, :profile_image, :nickname, :is_deleted, :created_at, :updated_at)
  end
end

