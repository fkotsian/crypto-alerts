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
    tickers = json.select {|r| markets.include? r["symbol"] }

    # got all ticker combos
    # now return by in-out currency? (BTC -> ETH, multiplied by USD ETH price?)
    tickers.map do |t|
      standard_rate(ex: self.name, ticker: t["symbol"], price: t["price"])
    end
  end
end
