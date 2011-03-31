require 'pacer'
require 'agent'

module PacerAgent
  unless const_defined? :VERSION
    PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
    VERSION = File.read(PATH + '/VERSION').chomp
    START_TIME = Time.now
    $:.unshift File.join(PATH, 'lib')
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


module PacerAgent
  def self.reload_time
    @reload_time || START_TIME
  end

  # Reload all Ruby modified files in the Pacer library. Useful for debugging
  # in the console. Does not do any of the fancy stuff that Rails reloading
  # does.  Certain types of changes will still require restarting the
  # session.
  def self.reload!
    require 'pathname'
    Pathname.new(File.expand_path(__FILE__)).parent.find do |path|
      if path.extname == '.rb' and path.mtime > reload_time
        puts path.to_s
        load path.to_s
      end
    end
    @reload_time = Time.now
  end
end

