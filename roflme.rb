require "rubygems"
require "bundler/setup"
Bundler.require(:default)
require "active_support/cache"

class Roflme < Sinatra::Base
  def rofls
    connection = Faraday.new(:url => 'http://knowyourmeme.com/search?utf8=%E2%9C%93&sort=score&q=rofl') do |conn|
      conn.response :caching do
        ActiveSupport::Cache::FileStore.new 'tmp/cache', :namespace => 'faraday', :expires_in => 3600
      end
      conn.adapter Faraday.default_adapter
    end
    response = connection.get
    doc = Nokogiri::HTML(response.body)
    doc.css("a.photo:not(.left) img").map{|img| {"rofl" => img["src"].gsub("medium", "large")}}
  end

  before do
    content_type :json
  end

  get '/' do
    rofls.to_json
  end

  get '/random' do
    rofls.sample.to_json
  end
end