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
require_relative './bittrex.rb'
require_relative './bitfinex.rb'
require 'ostruct'

USD_EXCHANGES = [
  GdaxTracker,
]

EXCHANGES = [
  BinanceTracker,
  BittrexTracker,
  BitfinexTracker,
]

class Aggregator
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
        standard_rate(
          ex: GdaxTracker.name,
          ticker: "#{buy.ticker}#{pay.ticker}",
          price: buy.price.to_f / pay.price.to_f,
        )
      }

    # use this return format
    pp "EXCHANGE RATES:"
    rates = EXCHANGES.map do |ex|
      ex.markets.map do |m|
        begin
          ex.ping(m)
        rescue
          #pp "ERROR FETCHING #{m} on #{ex.name}:\n#{e}"
        end
      end
    end.flatten.compact
    pp rates

    pp "COMPARE!"
    matches = rates.reduce({}) do |acc,r|
      acc[r.tokens] ||= []
      acc[r.tokens].push(r) if !acc[r.tokens].include?(r)
      acc
    end
    pp matches
    matches.each do |pair,rts|
      pp pair
      pp rts
      max_rate = rts.max{|r| r.price}
      min_rate = rts.min{|r| r.price}
      pp [
        max_rate.ex,
        min_rate.ex,
        max_rate.price,
        min_rate.price,
        (max_rate.price/min_rate.price)*100
      ]
    end
  end
end
