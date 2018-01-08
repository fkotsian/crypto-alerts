# GDAX price puller
require 'rest-client'

GDAX_API = 'https://api.gdax.com'

class GdaxTracker
  def self.name
    "GDAX"
  end

  def self.ping(ticker)
    res = RestClient.get("#{GDAX_API}/products/#{ticker}-USD/ticker")
    json = JSON.parse(res)
    json["price"]
  end
end
