module Pacer
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
