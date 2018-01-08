require 'rest-client'
require 'ostruct'

API = 'https://api.binance.com'

class BinanceTracker
  def self.name
    "Binance"
  end

  def self.ping(ticker)
    res = RestClient.get("#{API}/api/v1/ticker/allPrices")
    json = JSON.parse(res)
    json["price"]
  end

  def self.all_tickers
    res = RestClient.get("#{API}/api/v1/ticker/allPrices")
    json = JSON.parse(res)
    ticker_comps = TICKERS
      .permutation(2).to_a
      .map {|combo| combo.join('') }
    tickers = json.select {|r| ticker_comps.include? r["symbol"] }

    # got all ticker combos
    # now return by in-out currency? (BTC -> ETH, multiplied by USD ETH price?)
    tickers.map do |t|
      OpenStruct.new(
        ticker: t["symbol"],
        buy: t["symbol"][0..2],
        in: t["symbol"][3..-1],
        price: t["price"],
      )
    end
  end
end
