require 'net/sftp'

class OrdersCreateJob < ApplicationJob
  queue_as :default

  SFTP_HOST = ENV.fetch("SFTP_HOST")
  SFTP_USER = ENV.fetch("SFTP_USER")
  SFTP_PASS = ENV.fetch("SFTP_PASS")

  def perform(order_data)
    Rails.logger.info "New Order Received: #{order_data}"
    order_number = order_data["id"]
    file_name = "DropShipOrder_#{order_number}.xml"
    local_path = Rails.root.join("tmp", file_name)
    remote_path = "/Orderdrop/#{file_name}"

    # Generating XML order file
    File.open(local_path, "W") do |file|
      file.write(generate_xml(order_data))
    end

    # Uploading to BoD via SFTP
    Net::SFTP.start(SFTP_HOST, SFTP_USER, password: SFTP_PASS) do |sftp|
      sftp.upload!(local_path, remote_path)
    end

    Rails.logger.info " Order #{order_number} sent to BoD"
  end

  private 

  def generate_xml(order_data)
    <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <BoD>
      <DropShipOrder>
        <OrderNumber>#{order["id"]}</OrderNumber>
        <Shipping>ParcelDHL</Shipping>
        <InvoiceNumber>INV#{order["id"]}</InvoiceNumber>
        <InvoiceFile>Invoice_#{order["id"]}.pdf</InvoiceFile>
        <Product>
          <EAN>#{order["line_items"].first["sku"]}</EAN>
          <Copies>#{order["line_items"].first["quantity"]}</Copies>
          <CustomsValue>#{order["line_items"].first["price"]}</CustomsValue>
        </Product>
        <ShippingAddress>
          <Street>#{order["shipping_address"]["address1"]}</Street>
          <ZIP>#{order["shipping_address"]["zip"]}</ZIP>
          <City>#{order["shipping_address"]["city"]}</City>
          <Country>#{order["shipping_address"]["country_code"]}</Country>
        </ShippingAddress>
      </DropShipOrder>
    </BoD>
    XML
  end
end
