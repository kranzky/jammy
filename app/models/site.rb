module App::Models
  class Site < Rote::Model
    alias_method :to_s, :name
    many_to_many :users
  end
end
