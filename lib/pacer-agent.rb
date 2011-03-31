require 'pacer'
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

  module Pipes
    class ChannelPipe < AbstractPipe
      def initialize(channel, timeout = nil)
        super()
        @channel = channel.clone
        @selector = Agent::Selector.new
        @selector.case(channel, :receive) do
          value = channel.receive
          if channel == value
            channel.close rescue nil
            raise StopIteration
          else
            value
          end
        end
        if timeout
          @selector.timeout(timeout) { raise StopIteration }
        end
      end

    protected

      def processNextStart
        @selector.select
      rescue StopIteration
        raise Pacer::NoSuchElementException
      end
    end
  end

  module Source
    module Channel

    protected

      def iterator_from_source(src)
        return super unless src.is_a? Agent::Channel
        Pacer::Pipes::ChannelPipe.new(src)
      end
    end
  end
end

module Agent
  class Channel
    include Enumerable

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
end
