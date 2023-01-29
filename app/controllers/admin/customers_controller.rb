class Admin::CustomersController < ApplicationController
  def index
    @customers = Customer.all.order("created_at DESC")
  end
  def show
    @customer = Customer.find(params[:id])
    @routines = @customer.routines.order("created_at DESC")
    # @routines = Routine.all.order("created_at desc")
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

