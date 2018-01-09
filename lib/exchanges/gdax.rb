# GDAX price puller
require 'rest-client'


class GdaxTracker
  def self.API
    'https://api.gdax.com'
  end

  def self.name
    "GDAX"
  end

  def self.ping(ticker)
    res = RestClient.get("#{self.API}/products/#{ticker}-USD/ticker")
    json = JSON.parse(res)
    json["price"]
  end
end
