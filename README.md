# Agent plugin for Pacer (pacer-agent)

This plugin adds the concurrency features from [Agent](https://github.com/igrigorik/agent) to [Pacer](https://github.com/pangloss/pacer).

For more information on Agent, check out this great blog post on
[Concurrency with Actors, Goroutines &amp; Ruby](http://www.igvita.com/2010/12/02/concurrency-with-actors-goroutines-ruby/).

It requires you to use JRuby in 1.9 mode. You can start an IRB session easily as follows:

    JRUBY_OPTS=--1.9 bundle exec irb

## Example

First let's create a channel from a route:

    channel = (0...100).to_route.channel

Now we can consume elements from the channel:

    channel.receive #=> 0
    channel.receive #=> 1

Or we can turn the channel back into a route:

    channel.to_route.map { |n| n.to_f }.limit 10

Let's do that with a few threads:

    threads = (0...5).map do
      Thread.new do
        Thread.current[:result] = channel.to_route.map { |n| sleep 0.1; n.to_f }.to_a
      end
    end

    => [#<Thread:0x619988c4 run>, #<Thread:0x26e22deb run>, #<Thread:0x4b34b33e run>, #<Thread:0x70e3d204 run>, #<Thread:0x4bd38cb3 run>]

Let's let our threads work themselves to death for a few seconds...

    threads

    => [#<Thread:0x619988c4 dead>, #<Thread:0x26e22deb dead>, #<Thread:0x4b34b33e dead>, #<Thread:0x70e3d204 dead>, #<Thread:0x4bd38cb3 dead>]

Yup. So what have we got?

    threads.each { |t| p t[:result] }

    [3.0, 4.0, 5.0, 16.0, 21.0, 26.0, 31.0, 36.0, 41.0, 46.0, 52.0, 57.0, 62.0, 67.0, 71.0, 76.0, 81.0, 87.0, 91.0, 96.0]
    [0.0, 1.0, 2.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0, 45.0, 50.0, 55.0, 60.0, 65.0, 70.0, 75.0, 80.0, 85.0, 90.0, 95.0]
    [10.0, 12.0, 13.0, 19.0, 23.0, 29.0, 33.0, 38.0, 44.0, 48.0, 54.0, 59.0, 64.0, 68.0, 74.0, 79.0, 84.0, 88.0, 94.0, 99.0]
    [9.0, 11.0, 14.0, 18.0, 24.0, 28.0, 34.0, 39.0, 43.0, 49.0, 53.0, 58.0, 63.0, 69.0, 73.0, 78.0, 83.0, 89.0, 93.0, 98.0]
    [6.0, 7.0, 8.0, 17.0, 22.0, 27.0, 32.0, 37.0, 42.0, 47.0, 51.0, 56.0, 61.0, 66.0, 72.0, 77.0, 82.0, 86.0, 92.0, 97.0]

There you have it, the elements in my range have been distributed evenly
down 5 different pipelines!

## Bugs

I think the idea is sound but my implementation has a couple of major
issues right now (including runaway processes) before anyone even thinks
of saying the word ready after the word production. See Project Status.

## Project Status

This is currently just a proof of concept / spike. Only TinkerGraph
elements are actually serializable right now so, so using this with
other element types will probably work rather poorly.

## TODO List

* Rather than turning the Channel into an enumerable, allow pacer to
  natively support reading data using a channel as a data source

## Contributing to pacer-agent
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Darrick Wiebe. See LICENSE.txt for
further details.

