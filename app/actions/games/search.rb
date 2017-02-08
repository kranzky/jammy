module App::Actions::Games
  class Search < Rote::Action
    param :query, ''

    def respond
      perform "search games"
      render Views::Games::List
    end

    def validate
      validates_not_null :query
      validates_type String, :query
      validates_length_range 0..20, :query
    end
  end
end
