require 'rest-client'

class BtccTracker
  def self.API
    "https://spotusd-data.btcc.com"
  end

  def self.name
    "BTCC"
  end

  def self.markets
    market_pairs("")
  end

  def self.ping(ticker)
    res = RestClient.get("#{self.API}/data/pro/ticker?symbol=#{ticker}")
    json = JSON.parse res
    standard_rate(ex: self.name, ticker: ticker, price: json["ticker"]["Last"])
  end
end
