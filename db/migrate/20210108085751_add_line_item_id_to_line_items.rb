class AddLineItemIdToLineItems < ActiveRecord::Migration[6.1]
  def change
    add_column :line_items, :lineItemId, :string
  end
end
