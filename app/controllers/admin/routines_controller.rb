class Admin::RoutinesController < ApplicationController
  def index
    @routines = Routine.all.order("created_at DESC")
  end

  def new
  end

  def show
  end

  def edit
  end

end
