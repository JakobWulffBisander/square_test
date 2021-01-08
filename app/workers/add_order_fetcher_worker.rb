class AddOrderFetcherWorker
  include Sidekiq::Worker

  def perform
    Squarespace::Api.new.get_orders_by_time
    AddOrderFetcherWorker.perform_in(30.seconds)
  end

end