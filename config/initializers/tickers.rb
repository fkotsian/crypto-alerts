require 'ostruct'

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

def standard_rate(ticker: , price: )
  tick = ticker.gsub(/-/, "")

  OpenStruct.new(
    ticker: tick,
    tokens: [tick[0..2], tick[3..-1]],
    price: price,
  )
end
