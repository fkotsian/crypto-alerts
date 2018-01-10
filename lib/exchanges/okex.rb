require 'rest-client'

class OkexTracker
  def self.API
    "https://okex.com/api/v1"
  end
  def self.name
    "OkEx"
  end

  def self.markets
    market_pairs("_").map(&:downcase)
  end

  def self.ping(ticker)
    res = RestClient.get("#{self.API}/ticker.do?symbol=#{ticker}")
    json = JSON.parse(res)
    standard_rate(ex: self.name, ticker: ticker, price: json["ticker"]["last"])
  end
end
