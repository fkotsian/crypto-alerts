require 'pp'
require_relative '../../config/initializers/tickers'
require_relative '../../lib/exchanges/aggregator'

desc "Compare Crypto prices!"
task :compare do
  Aggregator.compare
end
