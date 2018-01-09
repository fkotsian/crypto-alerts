require 'ostruct'
require 'set'

TICKERS = [
  "ETH",
  "BTC",
  "LTC",
]

def market_pairs(join_sym="")
  TICKERS
    .permutation(2).to_a
    .map {|combo| combo.join("#{join_sym}") }
end

def standard_rate(ex: , ticker: , price: )
  tick = ticker.gsub(/-/, "")

  OpenStruct.new(
    ex: ex,
    ticker: tick,
    tokens: Set.new([tick[0..2], tick[3..-1]]),
    price: price.to_f,
  )
end
