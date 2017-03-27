# frozen_string_literal: true
require 'grape'
require 'grape-entity'

module WikiGame
  module Entities
    class Engine < Grape::Entity
      expose :connection_between_pages, documentation: { type: Array, desc: 'Path between two wikipedia pages.' }
    end
  end

  class API < Grape::API
    version 'v1', using: :header, vendor: 'wiki_game'
    format :json
    prefix :api

    desc 'Return a path between wikipedia pages.'
    params do
      requires :from, type: String
      requires :to, type: String
    end
    get :connect do
      start_page = params[:from]
      target_page = params[:to]
      strategy = ::WikiGame::Algorithms::BreadthFirstSearch.new
      engine = ::WikiGame::Engine.new(start_page, target_page, strategy)
      present engine.connection_between_pages, WikiGame::Entities::Engine
    end
  end
end
