class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!
  def top
    @routines = Routine.where(public_status:true).order("created_at DESC").all
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

  private
  def customer_params
    params.require(:customer).permit(:customer_id, :profile_image, :nickname, :email, :is_deleted, :created_at, :updated_at)
  end
end
