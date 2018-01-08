# Aggregator:
# - ping tickers w each client
# - aggregate prices/ticker
# - normalize to USD
# - alert if price is 5/10/15/20% different
#
# Example:
# GDAX ETH-USD: 1000
# Binance ETH-BTC: .00095 * (BTC=15000)
#
# return in USD and in ETH-BTC combos or whatever
require_relative './gdax.rb'
require_relative './binance.rb'
require 'ostruct'

EXCHANGES = [
  GdaxTracker,
  BinanceTracker,
]

class ExchangeComparer
  def self.compare
    base_prices = TICKERS.map do |t|
      dp = OpenStruct.new
      dp["ticker"] = t
      dp["price"] = GdaxTracker.ping(t)
      dp
    end
    pp "BASE PRICES (USD):"
    pp base_prices
    pp "GDAX EXCHANGE RATES:"
    pp base_prices.to_a
      .permutation(2)
      .to_a
      .map { |combo|
        buy = combo.first
        pay = combo.last
        OpenStruct.new(
          ticker: "#{buy.ticker}#{pay.ticker}",
          buy: buy.ticker,
          in: pay.ticker,
          price: buy.price.to_f / pay.price.to_f,
        )
      }

    # use this return format
    pp "EXCHANGE RATES:"
    pp BinanceTracker.all_tickers
    nil
  end
end
