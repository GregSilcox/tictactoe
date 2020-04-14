require 'redis'
require 'json'

class Memory
  attr_reader :redis

  def initialize
  end

  # redis-cli
    # -h redis-14070.c60.us-west-1-2.ec2.cloud.redislabs.com
    # -p 14070
    # -a S1xO4exkA2aexFRXZh3wgUVKFD5QEAU9
  def remote
    @host = 'redis-14070.c60.us-west-1-2.ec2.cloud.redislabs.com'
    @port = 14070
    @password = 'S1xO4exkA2aexFRXZh3wgUVKFD5QEAU9'
  end

  def local
    @host = 'localhost'
    @port = 6379
    @password = nil
  end

  def connect
    @redis = Redis.new host: @host, port: @port, password: @password
  end

  def get key
    redis.get key
  end

  def mget keys
    redis.mget keys
  end

  def set key, value
    redis.set key, value
  end

  def identifier type
    loop do
      charset = Array('A'..'Z') + Array('a'..'z') + Array(0..9)
      id = Array.new(4) { charset.sample }.join
      string = "#{ type }:#{ id }"
      return id unless redis.get(string)
    end
  end
end
