require 'agent'

module PacerAgent
  unless const_defined? :VERSION
    PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
    VERSION = File.read(PATH + '/VERSION').chomp
  end

  def self.reload!
    load __FILE__
  end
end

module Pacer
  module Core
    module Route
      def channel(opts = {})
        name = (inspect_strings + [hash]).join('_').gsub(/\W/, '_').to_sym
        opts = {
          :name => name,
          :type => element_type,
          :limit => 1
        }.merge(opts)
        channel = Agent::Channel.new opts
        go(channel, self) do |c, r|
          r.each do |elem|
            c << elem
          end
          c << c
        end
        channel
      end
    end
  end
end

module Agent
  class Channel
    include Enumerable

    def to_route
      r = Pacer::Route.new :source => self, :element_type => Object, :route_name => "|#{ name }|"
      r.route
    end

    def each
      return to_enum unless block_given?
      while not closed?
        value = receive
        return close if self == value
        yield value
      end
    end

    def ==(other)
      other.is_a?(Channel) and
        other.name == name and
          other.type == type and
            other.instance_variable_get('@direction') == @direction
    end
  end
end
