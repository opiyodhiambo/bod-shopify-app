# frozen_string_literal: true

class HomeController < ApplicationController
  include ShopifyApp::EmbeddedApp
  include ShopifyApp::EnsureInstalled
  include ShopifyApp::ShopAccessScopesVerification

  DEV_INDEX_PATH = Rails.root.join("frontend")
  PROD_INDEX_PATH = Rails.public_path.join("dist")

  def index
    index_path = File.join(Rails.env.production? ? PROD_INDEX_PATH : DEV_INDEX_PATH, "index.html")
    Rails.logger.info "Attempting to read: #{index_path}"
    
    if File.exist?(index_path)
      Rails.logger.info "index.html found. Rendering..."
      contents = File.read(index_path)
      contents.sub!("%VITE_SHOPIFY_API_KEY%", ShopifyApp.configuration.api_key)
      render(plain: contents, content_type: "text/html", layout: false)
    else
      Rails.logger.error "index.html not found at: #{index_path}"
      render(plain: "index.html not found", status: 500)
    end
  end  
end
