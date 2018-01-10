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
Dir[File.dirname(__FILE__) + "/*.rb"].each do |tracker|
  require_relative(tracker)
end
require 'ostruct'

USD_EXCHANGES = [
  GdaxTracker,
]

US_EXCHANGES = [
  GdaxTracker,
  BinanceTracker,
  BittrexTracker,
  PoloniexTracker,
  #symbols are wack KrakenTracker,
  HitbtcTracker,
]
EUR_EXCHANGES = [
  BitfinexTracker,
  OkexTracker,
  HuobiTracker,
  CryptopiaTracker,
]
EXCHANGES = [
  US_EXCHANGES,
  EUR_EXCHANGES,
].reduce([]) {|acc, ex| acc.concat ex; acc}

class Aggregator
  def self.compare
    base_prices = USD_MARKETS.map do |t|
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
