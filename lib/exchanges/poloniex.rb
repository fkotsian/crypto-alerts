require 'rest-client'

class PoloniexTracker
  def self.API
    "https://poloniex.com/public"
  end

  def self.name
    "Poloniex"
  end

  def self.markets
    market_pairs("_")
  end

  def self.ping(ticker)
    json = all_tickers[ticker]["last"]
    standard_rate(ex: self.name, ticker: ticker, price: json)
  end

  def self.all_tickers
    res = RestClient.get("#{self.API}?command=returnTicker")
    json = JSON.parse(res)
    json
  end
end
