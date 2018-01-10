# GDAX price puller
require 'rest-client'


class GdaxTracker
  def self.API
    'https://api.gdax.com'
  end

  def self.name
    "GDAX"
  end

  def self.markets
    market_pairs("-")
  end

  def self.ping(ticker)
    res = RestClient.get("#{self.API}/products/#{ticker}/ticker")
    json = JSON.parse(res)
    standard_rate(ex: self.name, ticker: ticker, price: json["price"])
  end
end
