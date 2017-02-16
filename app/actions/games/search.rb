module App::Actions::Games
  class Search < Rote::Action
    # TODO: type conversion, maybe via virtus
    param :query, ''
    param :page

    def respond
      perform "search games"
      render Views::Games::List
      # render "games list"
    end

    # validate page >= 1
    def validate
      validates_not_null :query
      validates_type String, :query
      validates_length_range 0..20, :query
      validates_not_null :page
      validates_type Integer, :page
    end
  end
end
