# frozen_string_literal: true
require 'json'
require 'logger'
require 'redis'

module WikiGame
  module Stores
    class Redis
      ENV_CONFIG = {
        host: '127.0.0.1',
        port: 6379,
        namespace: 'en_wikipedia',
        db: 0
      }.freeze

      @@client = ::Redis.new(ENV_CONFIG)
      @@logger = ::Logger.new(File.new('tmp/redis_store.log', 'w'))

      class << self
        def client
          @@client
        end

        def add(key, value)
          value = value.to_json unless value.is_a?(String)
          @@client.set(key.to_s, value) == 'OK'
        end

        def get(key)
          value = @@client.get(key.to_s)
          return unless value
          ::JSON.parse(value)
        rescue ::JSON::ParserError => ex
          @@logger.error "JSON.parse could not parse value: #{value}"
          @@logger.error ex
        end

        def delete(key)
          @@client.del(key.to_s) == 1
        end

        def exists?(key)
          @@client.exists(key.to_s)
        end

        def reconnect(env_config = ENV_CONFIG)
          @@client = ::Redis.new(env_config)
        end

        def flushdb
          @@client.flushdb
        end
      end
    end
  end
end
