class SearchesController < ApplicationController
    before_action :authenticate_customer!

  def search
    @range = params[:range]

    if @range == "customer"
      @customers = Customer.looks(params[:search], params[:word])
    else
      @routines = Routine.looks(params[:search], params[:word])
    end
  end
    
end
