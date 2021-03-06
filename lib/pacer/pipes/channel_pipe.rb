module Pacer
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
            if channel.receive?
              channel << value
            else
              channel.close rescue nil
            end
            raise StopIteration
          else
            value
          end
        end
        if timeout
          @selector.timeout(timeout) { raise StopIteration }
        end
        if @channel.closed?
          @selector.default { raise StopIteration }
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
end
