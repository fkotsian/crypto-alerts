require 'rest-client'
require 'ostruct'

class BinanceTracker
  def self.API
    "https://api.binance.com/api/v1"
  end

  def self.name
    "Binance"
  end

  def self.markets
    market_pairs("")
  end

  def self.ping(ticker)
    all_tickers.select {|t| t.ticker == ticker}[0]
  end

  def self.all_tickers
    res = RestClient.get("#{self.API}/ticker/allPrices")
    json = JSON.parse(res)
    ticker_comps = market_pairs("")
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
