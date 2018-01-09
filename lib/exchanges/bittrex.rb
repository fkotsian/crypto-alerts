require 'rest-client'
require 'ostruct'

class BittrexTracker
  def self.API
    "https://bittrex.com/api/v1.1/public"
  end

  def self.name
    "Bittrex"
  end

  def self.markets
    market_pairs("-")
  end

  def self.ping(ticker)
    res = RestClient.get("#{self.API}/getticker?market=#{ticker}")
    json = JSON.parse(res)["result"]
    OpenStruct.new(
      ticker: ticker.gsub(/-/,""),
      buy: ticker[0..2],
      in: ticker[4..-1],
      price: json["Last"],
    )
  end
end

