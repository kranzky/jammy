module App::Models
  class Site < Rote::Model
    alias_method :to_s, :name
  end
end
