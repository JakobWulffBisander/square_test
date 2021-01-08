class AddressesController < ApplicationController
  def index
    @address = Address.all
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(order_params)

    if @address.save
      # Redirect to view if needed
    end

  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
  end

  def destroy
    @address = Address.find(params[:id])
  end
end
