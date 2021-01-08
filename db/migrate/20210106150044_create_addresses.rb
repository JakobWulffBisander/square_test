class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :firstName
      t.string :lastName
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :countryCode
      t.string :postalCode
      t.string :phone
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
