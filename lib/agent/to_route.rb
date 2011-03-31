module Agent
  module ToRoute
    def to_route(opts = {})
      opts = {
        :source => self,
        :element_type => Object,
        :route_name => "|#{ name }|",
        :transform => Pacer::Source::Channel
      }.merge(opts)
      Pacer::Route.new(opts).route
    end

    def ==(other)
      other.is_a?(Channel) and
        other.name == name and
          other.instance_variable_get('@type') == @type and
            other.instance_variable_get('@direction') == @direction
    end

    def clone
      Marshal.load(Marshal.dump(self))
    end
  end

  class Channel
    include ToRoute
  end
end
