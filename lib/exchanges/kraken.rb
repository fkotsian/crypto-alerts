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
    # Kraken calls BTC by XBT
    if ticker.include? "BTC"
      ticker.gsub!(/BTC/, "XBT")
    end

    res = RestClient.get("#{self.API}/Ticker?pair=#{ticker}")
    json = JSON.parse(res)["result"]
    keys = json.keys
    # Use .keys to get the first key in the result array;
    # "c" key returns last transaction [price, volume]
    # See: https://api.kraken.com/0/public/Ticker?pair=XBTUSD
    standard_rate(ex: self.name, ticker: ticker, price: json[keys[0]]["c"].first)
  end
end
