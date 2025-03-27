require 'net/sftp'

class OrdersFulfilledJob < ApplicationJob
  queue_as :default

  SFTP_HOST = ENV.fetch("SFTP_HOST")
  SFTP_USER = ENV.fetch("SFTP_USER")
  SFTP_PASS = ENV.fetch("SFTP_PASS")

  def perform(order_data)
    Rails.logger.info "Order #{order_data} fulfilled"

    order_number = order_data["id"]
    remote_conf_path = "/Shipconf/SC_#{order_number}.xml"
    local_conf_path = Rails.root.join("tmp", "SC_#{order_number}.xml")

    # Download the shipping confirmation from BoD
    Net::SFTP.start(SFTP_HOST, SFTP_USER, password: SFTP_PASS) do |sftp|
      sftp.download!(remote_conf_path, local_conf_path)
    end

    # Parsing the tracking information from XML
    tracking_number = extract_tracking_number(local_conf_path)
    if tracking_number
      update_shopify_fulfillment(order_number, tracking_number)
    else
      Rails.logger.warn "No tracking number found for Order #{order_number}"
    end
  end

  private
  def extract_tracking_number(local_conf_path)
    xml = Nokogiri::XML(File.read(local_conf_path))
    xml.at_xpath("//TrackingNo")&.text
  end 

  def update_shopify_fulfillment(order_number, tracking_number)
     shop_url = "https://#{ENV['SHOPIFY_SHOP_NAME']}.myshopify.com/admin/api/2025-01/orders/#{order_id}/fulfillments.json"
     payload = {
      fulfillment: {
        tracking_number: tracking_number,
        tracking_company: "DHL"
      } 
     }

     response = HTTParty.post(
      shop_url,
      body: payload.to_json,
      headers: {
        "Content-Type" => "application/json",
        "X-Shopify-Access-Token" => ENV["SHOPIFY_API_SECRET"]
      }
     )

    if response.success?
      Rails.logger.info "Fulfillment updated for Order #{order_id} with tracking #{tracking_number}"
    else
      Rails.logger.error "Failed to update fulfillment for Order #{order_id}: #{response.body}"
    end
  end
end
