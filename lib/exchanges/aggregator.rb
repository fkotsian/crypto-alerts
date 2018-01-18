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
#
# 1. BTC arb in USD -> other
# - start w US exchange
# - move to EUR or other US exchange
# - display if arb rate >= 3%
Dir[File.dirname(__FILE__) + "/*.rb"].each do |tracker|
  require_relative(tracker)
end
require 'ostruct'

USD_EXCHANGES = [
  GdaxTracker,
]

IN_EXCHANGES = [
  GdaxTracker,
]
OUT_EXCHANGES = [
  BinanceTracker,
  BittrexTracker,
  PoloniexTracker,
  #symbols are wack KrakenTracker,
  HitbtcTracker,
  BitfinexTracker,
  OkexTracker,
  HuobiTracker,
  CryptopiaTracker,
]
EXCHANGES = [
  IN_EXCHANGES,
  OUT_EXCHANGES,
].reduce([]) {|acc, ex| acc.concat ex; acc}

REQUIRED_DIFF = 0.03

class Aggregator
  def self.compare
    #pp "#{market_pairs.length**2} requests per exchange, #{EXCHANGES.length} exchanges = #{market_pairs.length**2 * EXCHANGES.length} requests."
    #base_prices = USD_MARKETS.map do |t|
    base_prices = ["BTC-USD"].map do |t|
      begin
        GdaxTracker.ping(t)
      rescue
      end
    end
    pp "BASE PRICES (USD):"
    pp base_prices

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
    profitable_matches = matches.map do |pair,rts|
      pp pair
      pp rts
      max_rate = rts.max{|r| r.price}
      min_rate = rts.min{|r| r.price}
      percent_diff = (1.0 * max_rate.price/min_rate.price)

      profit = [
        max_rate.ex,
        min_rate.ex,
        max_rate.price,
        min_rate.price,
        "Spread: #{(100 - percent_diff*100).round(2)}%",
      ]
      pp profit
      # select ones greater than DIFF from 100
      #profit if (percent_diff > 1+REQUIRED_DIFF) || (percent_diff < 1-REQUIRED_DIFF)
      profit
    end.compact

    pp "PROFITABLE MATCHES!"
    pp profitable_matches
  end
end
