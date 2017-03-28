# frozen_string_literal: true
require 'redis'

module WikiGame
  module DataStores
    class RedisStore
      ENV_CONFIG = {
        host: '127.0.0.1',
        port: 6379,
        namespace: 'en_wikipedia',
        db: 0
      }.freeze

      @@client = Redis.new(ENV_CONFIG)

      class << self
        def client
          @@client
        end

        def add(key, value)
          @@client.set(key, value)
        end

        def get(key)
          @@client.get(key)
        end

        def delete(key)
          @@client.del(key)
        end

        def exists?(key)
          @client.exists(key)
        end

        def reconnect
          @@client = Redis.new(ENV_CONFIG)
        end

        def flushdb
          @@client.flushdb
        end
      end
    end
  end
end
