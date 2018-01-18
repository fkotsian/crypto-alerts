require 'rest-client'

class HitbtcTracker
  def self.API
    "https://api.hitbtc.com/api/2"
  end

  def self.name
    "HitBTC"
  end

  def self.markets
    market_pairs("")
  end

  def self.ping(ticker)
    # note: can withdraw/trade USD on BTC, after verification
    # - USD/USDT confusion is not a lie *can trade in USD and USDT, but is unclear which is which - perhaps after verification it becomes clearer?*

    res = RestClient.get("#{self.API}/public/ticker/#{ticker}")
    json = JSON.parse(res)
    standard_rate(ex: self.name, ticker: ticker, price: json["last"])
  end
end
