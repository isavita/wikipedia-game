# frozen_string_literal: true
require 'grape'

module WikiGame
  class API < ::Grape::API
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
      engine.connection_between_pages.to_json
    end
  end
end
