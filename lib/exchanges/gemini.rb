require 'rest-client'

class GeminiTracker
  def self.API
    "https://api.gemini.com/v1"
  end

  def self.name
    "Gemini"
  end

  def self.markets
    market_pairs("").map(&:downcase)
  end

  def self.ping(ticker)
    res = RestClient.get("#{API}/pubticker/#{ticker}")
    json = JSON.parse res
    standard_rate(ex: self.name, ticker: ticker, price: json["last"])
  end
end
