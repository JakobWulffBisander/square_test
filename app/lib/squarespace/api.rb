module Squarespace
  require 'httpclient'
  class Api
    def initialize
      @apiVersion = "1.0"
      @resourcePath = "commerce/orders"
      @apiKey = "aaf0ca10-7f59-43a6-8e6d-e640d63d9c33"
      @auth = "Bearer "+ @apiKey
      @client = HTTPClient.new
      @headers = {"Authorization": @auth, "User-Agent": "ruby_integration"}
      @last_updated_at = "2018-01-07T10:11:28Z"
      @immutable_order_attributes = %w[id orderId orderNumber created_at updated_at]
      @immutable_line_item_attributes = %w[id order_id lineItemId created_at updated_at]
      @immutable_address_attributes = %w[id order_id created_at updated_at addressType]
    end

    def get_all_orders
      url = "https://api.squarespace.com/"+@apiVersion+"/"+@resourcePath
      response = @client.get(url, nil, @headers)
      data = JSON.parse(response.body)
    end

    def get_orders_by_time
      modified_before = Time.zone.now.iso8601
      puts "Fetching order in the given time interval:"
      puts @last_updated_at
      puts modified_before
      url = "https://api.squarespace.com/"+@apiVersion+"/"+@resourcePath+"?modifiedAfter="+@last_updated_at+"&modifiedBefore="+modified_before
      response = @client.get(url, nil, @headers)
      data = JSON.parse(response.body)

      data["result"].each do |order|

        puts "Finding matching order"
        duplicate_order = Order.find_by(orderId: order["id"])
        if duplicate_order.nil?
          puts "No matching order found, creating new"
          create_order(order)
        else
          puts "Matching order found, checking for updated attributes"
          update_order(duplicate_order, order)
        end

      end
      @last_updated_at = modified_before
    end


    def create_order(order)
      new_order = Order.create(orderId: order["id"], orderNumber: order["orderNumber"], customerEmail: order["customerEmail"])
      create_address(new_order, order["shippingAddress"], "shipping")
      create_address(new_order, order["billingAddress"], "billing")
      create_line_items(new_order, order)
      return new_order
    end


    def update_order(original_order, modified_order)

      update_attributes(original_order, modified_order, @immutable_order_attributes)

      original_shipping_address = Address.find_by(order_id: original_order["id"], addressType: 0)
      #new_shipping_address = modified_order["shippingAddress"]

      update_attributes(original_shipping_address, modified_order["shippingAddress"], @immutable_address_attributes)


      original_billing_address = Address.find_by(order_id: original_order["id"], addressType: "billing")
      new_billing_address = modified_order["billingAddress"]

      update_attributes(original_billing_address, modified_order["billingAddress"], @immutable_address_attributes)
      puts "Updating line items for order"
      modified_order["lineItems"].each do |line_item|
        original_lineItem = LineItem.find_by(order_id: original_order["id"], lineItemId: line_item["id"])

        if original_lineItem.nil?
          # Create new lineItem
          create_line_items(original_order, modified_order)
        else
          # Update old lineItem
          update_attributes(original_lineItem, line_item, @immutable_line_item_attributes)
        end
      end
    end

    def update_attributes(original, modified, immutable_attributes)
      changed_attributes = {}
      original.attributes.each do |attr_name, attr_value|
        next if immutable_attributes.include? attr_name
        new_attr_value = modified[attr_name]
        next if attr_value == new_attr_value
        changed_attributes[attr_name] = new_attr_value
      end
      if !changed_attributes.empty?
        original.update(changed_attributes)
      end
      return changed_attributes
    end

    def create_address(order, address, type)
      created_address= order.addresses.create(
        firstName: address["firstName"],
        lastName: address["lastName"],
        address1: address["address1"], address2: address["address2"],
        city: address["city"],
        state: address["state"],
        countryCode: address["countryCode"],
        postalCode: address["postalCode"],
        phone: address["phone"],
        addressType: type)
      return created_address
    end

    def create_line_items(db_order, external_order)
      external_order["lineItems"].each do |lineItem|
        db_order.line_items.create(
          productId: lineItem["productId"],
          productName: lineItem["productName"],
          variantId: lineItem["variantId"],
          quantity: lineItem["quantity"],
          lineItemId: lineItem["id"])
      end
    end

    def single
      orderId = "5f0c19c5cf7142239e51f413"
      url = "https://api.squarespace.com/"+@apiVersion+"/"+@resourcePath+"/"+orderId
      response = @client.get(url, nil, @headers)
      data = JSON.parse(response.body)

      order = create_order(data)

      finished_order = Order.find(order.id)
      puts order.inspect
      puts finished_order.addresses.inspect
      puts finished_order.line_items.inspect
    end
  end
end
