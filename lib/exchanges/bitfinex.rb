require 'rest-client'
require 'ostruct'

class BitfinexTracker
  def self.API
    "https://api.bitfinex.com/v2"
  end

  def self.name
    "Bitfinex"
  end

  def self.markets
    market_pairs("")
  end

  # https://bitfinex.readme.io/v2/reference#rest-public-ticker
  # On trading pairs (ex. tBTCUSD):
  # [
  #   BID,
  #   BID_SIZE,
  #   ASK,
  #   ASK_SIZE,
  #   DAILY_CHANGE,
  #   DAILY_CHANGE_PERC,
  #   LAST_PRICE,
  #   VOLUME,
  #   HIGH,
  #   LOW
  # ]
  def self.ping(ticker)
    res = RestClient.get("#{self.API}/ticker/t#{ticker}")
    json = JSON.parse(res)
    standard_rate(ticker: ticker, price: json[6])
  end

  def self.ping_currency(curr)
  end
end
