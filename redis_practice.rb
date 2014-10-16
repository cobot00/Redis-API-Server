#!/usr/bin/ruby
# encoding: utf-8

require "sinatra"
require "json"
require "redis"

DATA_SET_RANKING = "ranking"

get "/" do
  @scores = redis_zrange
  @title = "It's Redis Entrance"
  @count = redis_zcard
  erb :index
end

get "/ranking" do
  content_type :json
  data = redis_zrange
  data.to_json
end

post "/ranking", provides: :json do
  params = JSON.parse(request.body.read)
  logger.info("params = #{params}")
  score = params["score"]
  user_id = params["user_id"]
  redis_zadd(score, user_id)

  content_type :json
  data = { result: "success" }
  data.to_json
end

def get_redis
  if ENV["REDISTOGO_URL"]
    redis = Redis.new(:url => ENV["REDISTOGO_URL"])
  else
    redis = Redis.new(:host => "127.0.0.1", :port => 6379)
  end

  return redis
end

def redis_zadd(score, user_id)
  redis = get_redis
  redis.zadd(DATA_SET_RANKING, score, user_id)
end

def redis_zcard
  redis = get_redis
  return redis.zcard(DATA_SET_RANKING)
end

def redis_zrange
  redis = get_redis
  scores = redis.zrevrange(DATA_SET_RANKING, 0, 9, :withscores => true)
  rank = 0
  result = []
  scores.each do |score|
    rank += 1
    data = {
      :user_id => score[0],
      :score => score[1],
      :rank => rank
    }
    result << data
  end
  logger.info(result)
  return result
end
