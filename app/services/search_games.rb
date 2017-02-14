module App::Services
  class SearchGames < Rote::Service
    argument :query
    argument :page
    result :games

    def perform
      self.games = Models::Game.offset(100 * (page - 1)).limit(100).order(:slug, :name).all
    end

    # validate page >= 1
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
