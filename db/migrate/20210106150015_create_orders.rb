class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :orderId
      t.string :orderNumber
      t.string :customerEmail

      t.timestamps
    end
  end
end
