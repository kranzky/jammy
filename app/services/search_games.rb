# TODO: paginate (for infinite scroll)
# TODO: sort (by key or rating)
# TODO: filter (has video, embeddable, has game, game engine, country, year)

module App::Services
  class SearchGames < Rote::Service
    argument :query
    result :games

    def perform
      self.games = Models::Game.where(embed: true).limit(100).order(:name).all
    end

    def validate_arguments
      validates_not_null :query
      validates_type String, :query
    end

    def validate_results
      validates_not_null :games
      validates_type Array, :games
    end
  end
end
