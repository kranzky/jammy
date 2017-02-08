module App::Views::Games
  class List < Rote::View
    template "games/list"
    local :games

    def title
      "Matching Games"
    end

    def validate
      validates_not_null :games
      validates_type Array, :games
    end
  end
end
