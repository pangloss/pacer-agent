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

require 'agent/to_route'
require 'pacer/pipes/channel_pipe'
require 'pacer/source/channel'

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

