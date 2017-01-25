module App::Models
  class Site
    alias_method :to_s, :name

    def validate
      validates_presence :name
    end
  end
end
