module App::Models
  class Game < Rote::Model
    alias_method :to_s, :name
    def validate
      validates_presence :name
      validates_presence :url
      validates_presence :image
      validates_presence :year
    end
  end
end
