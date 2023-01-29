class Public::BookmarksController < ApplicationController


  before_action :authenticate_customer!

  def create
    @routine = Routine.find(params[:routine_id])
    bookmark = @routine.bookmarks.new(customer_id: current_customer.id)
    if bookmark.save
      redirect_to request.referer
    else
      redirect_to request.referer
    end
  end

  def destroy
    @routine = Routine.find(params[:routine_id])
    bookmark = @routine.bookmarks.find_by(customer_id: current_customer.id)
    if bookmark.present?
        bookmark.destroy
        redirect_to request.referer
    else
        redirect_to request.referer
    end
  end

  def show

  end
  def index

  end
end

