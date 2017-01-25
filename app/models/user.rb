module App::Models
  class User < Rote::Model
    alias_method :to_s, :name
    many_to_many :sites
  end
end
