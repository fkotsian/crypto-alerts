require 'ostruct'
require 'set'

TICKERS = [
  "USD",
  "ETH",
  "BTC",
  "LTC",
  "NEO",
  "XLM",
  "XEM",
  "EOS",
  "ZRX",
]

def market_pairs(join_sym="")
  TICKERS
    .permutation(2).to_a
    .map {|combo| combo.join("#{join_sym}") }
    # Comment out selects to include all currency pairs
    # include all currency pairs at this time - not just those that come in btc
end

def standard_rate(ex: , ticker: , price: )
  tick = ticker.gsub(/[-_]/, "").upcase

  OpenStruct.new(
    ex: ex,
    ticker: tick,
    tokens: Set.new([tick[0..2], tick[3..-1]]),
    price: price.to_f,
  )
end
