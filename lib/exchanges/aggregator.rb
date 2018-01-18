require 'twilio-ruby'

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
  GeminiTracker,
  KrakenTracker,
  HitbtcTracker,
  BitfinexTracker,
  BtccTracker,
  OkexTracker,
  HuobiTracker,
  CryptopiaTracker,
]

REQUIRED_DIFF = 0.03

RECIPIENTS = [
  '+13104835624',
]

class CurrencyArbiter
  def self.compare_one_stage(in_curr: "USD", out_curr: "USD", medium: "BTC", us_only: false)

    # in rates
    pp "COMPARING #{medium} in #{in_curr} to #{out_curr}!"
    base_rates = IN_EXCHANGES.map do |ex|
      ex.markets
        .select {|p| p.include? medium}
        .select {|p| p.include? in_curr}
        .map do |t|
          begin
            GdaxTracker.ping(t)
          rescue
          end
      end
    end.flatten.compact
    pp "BASE PRICES (#{in_curr}):"
    pp base_rates

    # out rates
    pp "EXCHANGE RATES:"
    out_rates = OUT_EXCHANGES.map do |ex|
      ex.markets
        .select {|p| p.include? medium}
        .select {|p| p.include? out_curr}
        .map do |m|
          begin
            ex.ping(m)
          rescue
            #pp "ERROR FETCHING #{m} on #{ex.name}:\n#{e}"
          end
      end
    end.flatten.compact
    pp out_rates

    # spreads
    spreads = base_rates
      .reduce({}) do |acc,base_rate|
        acc[base_rate.tokens] = out_rates.map do |out_rate|
          percent_diff = (1.0 * base_rate.price/out_rate.price)

          spread = [
            base_rate.ex,
            out_rate.ex,
            base_rate.price,
            out_rate.price,
            (100 - percent_diff*100).round(2),
          ]
          # select ones greater than DIFF from 100
          #spread if (percent_diff > 1+REQUIRED_DIFF) || (percent_diff < 1-REQUIRED_DIFF)
          spread
        end
        acc
    end

    # TODO: notify if spreads large enough

    pp "SPREADS"
    pp spreads

    @twilio = Twilio::REST::Client.new(
      Rails.application.secrets.twilio_account_sid,
      Rails.application.secrets.twilio_auth_token,
    )
    spreads.each do |pair, ss|
      ss.each do |s|
        if s.last > 0
          # send message instead of / in addition to output
          l1 = "PROFITABLE SPREAD for pair #{pair.to_a.join(",")} of #{s.last}%, #{s.first} => #{s.second}."
          profit = (1000*s.last/100.0) - 10 - 10 - (1000*0.005)
          l2 = "At transaction size of $1000 and fixed costs of $20, profit is: $ #{sprintf('%.2f', profit)} (#{(profit/1000.0 * 100).round(2)}% ROI) **"
          p l1
          p l2
        end

        if s.last > 1
          RECIPIENTS.each do |receiver|
            @twilio.messages.create(
              body: "#{l1} #{l2}",
              to: receiver,
              from: '+16508894472',
            )
          end
        end
      end
    end
    p "*" * 100
  end
end
