class Public::CustomersController < ApplicationController
  def show
  end

  def edit
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
