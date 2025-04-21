require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require "dotenv/load"

API_KEY = ENV.fetch("EXCHANGE_RATE_KEY")

get("/") do
  url = "https://api.exchangerate.host/list?access_key=#{API_KEY}"
  response = HTTP.get(url)
  parsed = JSON.parse(response.to_s)

  @symbols = parsed["currencies"].keys.sort
  erb :homepage
end

get("/:from_currency") do
  @from_currency = params.fetch("from_currency")

  url = "https://api.exchangerate.host/list?access_key=#{API_KEY}"
  response = HTTP.get(url)
  parsed = JSON.parse(response.to_s)

  @symbols = parsed["currencies"].keys.sort
  erb :convert_from
end

# 汇率结果页面
get("/:from_currency/:to_currency") do
  @from_currency = params.fetch("from_currency")
  @to_currency = params.fetch("to_currency")

  url = "https://api.exchangerate.host/convert?from=#{@from_currency}&to=#{@to_currency}&amount=1&access_key=#{API_KEY}"
  response = HTTP.get(url)
  parsed = JSON.parse(response.to_s)

  @rate = parsed["result"]
  erb :conversion_result
end
