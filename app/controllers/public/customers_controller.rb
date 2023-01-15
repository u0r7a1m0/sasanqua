class Public::CustomersController < ApplicationController
  def show
    @customer = current_customer
    @routines = current_customer.routines
    # @routine = Routine.find(params[:id])
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
    # 更新に成功したときの処理
      flash[:notice]="更新完了しました！"
      redirect_to my_page_path
    else
      render 'edit'
    end
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
  def frequency_params
    params.require(:frequency).permit(:routine_id, :frequency)
  end
end
