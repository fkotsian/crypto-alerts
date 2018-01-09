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
