require 'rest-client'

class KrakenTracker
  def self.API
    "https://api.kraken.com/0/public"
  end

  def self.name
    "Kraken"
  end

  # Kraken's market pairs are busto. Remove for now
  # See: https://api.kraken.com/0/public/AssetPairs (X's and Z's everywhere - figure out pattern)
  def self.markets
    market_pairs("")
  end

  def self.ping(ticker)
    res = RestClient.get("#{self.API}/Ticker?pair=#{ticker}")
    json = JSON.parse(res)
    standard_rate(ex: self.name, ticker: ticker, price: json["result"][ticker]["c"])
  end
end
