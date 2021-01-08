class AddFulfillmentStatusToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :fulfillmentStatus, :string
  end
end
