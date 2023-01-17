class Admin::RoutinesController < ApplicationController
  def index
    @routines = Routine.all
  end

  def new
  end

  def show
  end

  def edit
  end

end
