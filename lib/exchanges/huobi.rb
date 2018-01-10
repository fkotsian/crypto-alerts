require 'rest-client'

class HuobiTracker
  def self.API
    "https://api.huobi.pro"
  end

  def self.name
    "Huobi"
  end

  def self.markets
    market_pairs("").map(&:downcase)
  end

  def self.ping(ticker)
    res = RestClient.get("#{self.API}/market/trade?symbol=#{ticker}")
    json = JSON.parse(res)
    standard_rate(ex: self.name, ticker: ticker, price: json["tick"]["data"][0]["price"])
  end
end
