require 'rest-client'

class CryptopiaTracker
  def self.API
    "https://www.cryptopia.co.nz/api"
  end

  def self.name
    "Cryptopia"
  end

  def self.markets
    market_pairs("_")
  end

  def self.ping(ticker)
    res = RestClient.get("#{self.API}/GetMarket/#{ticker}")
    json = JSON.parse(res)
    standard_rate(ex: self.name, ticker: ticker, price: json["Data"]["LastPrice"])
  end
end
