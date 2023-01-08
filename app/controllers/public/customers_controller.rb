class Public::CustomersController < ApplicationController
  def show
    @customer = current_customer
    @routines = current_customer.routines
  end

  def edit

  end
  def withdraw
    @customer = current_customer
		#is_deletedカラムにフラグを立てる(defaultはfalse)
    @customer.update(is_deleted: true)
    #ログアウトさせる
    reset_session
    flash[:notice] = "ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end
  private
  def customer_params
    params.require(:customer).permit(:customer_id, :profile_image, :nickname, :is_deleted, :created_at, :updated_at)
  end
  def routine_params
    params.require(:routine).permit(:target, :routine_image, :public_status, :customer_id)
  end
  def task_params
    params.require(:task).permit(:routine_id, :main_task, :sub_task)
  end
  def implementation_time_params
    params.require(:implementation_time).permit(:accurate_time, :approximate_time, :routine_id)
  end
  def frequencie_params
    params.require(:frequencie).permit(:routine_id, :frequencie)
  end
end
