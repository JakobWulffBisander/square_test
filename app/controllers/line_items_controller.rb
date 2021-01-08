class LineItemsController < ApplicationController
  def index
    @lineitems = LineItem.all
  end

  def new
    @lineitems = LineItem.new
  end

  def create
    @lineitems = LineItem.new(order_params)

    if @lineitems.save
      # Redirect to view if needed
    end

  end

  def edit
    @lineitems = LineItem.find(params[:id])
  end

  def update
    @lineitems = LineItem.find(params[:id])
  end

  def destroy
    @lineitems = LineItem.find(params[:id])
  end
end
