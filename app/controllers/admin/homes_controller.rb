class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!
  def top
    # @customer = current_customer
    @routines = Routine.order("created_at DESC").page(params[:page]) 

    @current_routines = []
    @backnumber_routines = []
    current_daytime = Time.current
    @routines.each do |routine|
      # created_at + period <=> current_day
      if routine.created_at.since(Period::TASK_DURATION_TABLE[routine.period.period.to_sym]).after?(current_daytime)
        @current_routines << routine
      else
        @backnumber_routines << routine
      end
    end
  end

  private
  def customer_params
    params.require(:customer).permit(:customer_id, :profile_image, :nickname, :email, :is_deleted, :created_at, :updated_at)
  end
end
