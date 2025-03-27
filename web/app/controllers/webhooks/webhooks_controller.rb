module Webhooks
  class WebhooksController < ApplicationController
    include ShopifyApp::WebhookVerification

    protect_from_forgery with: :null_session

    def orders_create
      order_data = JSON.parse(request.body.read)
      OrdersCreateJob.perform_later(order_data)
      render json: { message: "Order received" }, status: :ok
    end

    def orders_fulfilled
      order_data = JSON.parse(request.body.read)
      OrderFulfilledJob.perform_later(order_data)
      render json: { message: "Fulfillment update received" }, status: :ok
    end
  end
end
