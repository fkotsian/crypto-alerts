require 'pp'
require_relative '../../config/initializers/tickers'
require_relative '../../lib/exchanges/aggregator'

desc "Compare Crypto prices!"
task :compare do
  CurrencyArbiter.compare_one_stage(in_curr: "USD", out_curr: "USD", medium: "BTC")
  CurrencyArbiter.compare_one_stage(in_curr: "USD", out_curr: "USD", medium: "ETH")
  CurrencyArbiter.compare_one_stage(in_curr: "USD", out_curr: "USD", medium: "LTC")
end
