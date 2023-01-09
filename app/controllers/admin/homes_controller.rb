class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!
  def top
    @customers = Customer.all
  end
  def customer_params
    params.require(:customer).permit(:customer_id, :profile_image, :nickname, :email, :is_deleted, :created_at, :updated_at)
  end
end
