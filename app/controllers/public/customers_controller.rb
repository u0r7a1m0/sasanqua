class Public::CustomersController < ApplicationController
  def show
    @customer = current_customer
    @routines = current_customer.routines.order("created_at DESC")
    @bookmark = current_customer.bookmarks


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
    params.require(:routine).permit(:target, :routine_image, :public_status, :customer_id,
                                    task_attributes: [:routine_id, :name, sub_tasks_attributes: %i(name) ],
                                    implementation_time_attributes: [:accurate_time, :approximate_time, :routine_id],
                                    frequency_attributes: [:routine_id, :frequency],
                                    period_attributes: [:routine_id, :period]
                                    )
  end
  def bookmark_params
    params.require(:bookmark).permit(:routine_id, :customer_id)
  end
end
