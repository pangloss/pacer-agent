# Agent plugin for Pacer (pacer-agent)

This plugin adds the concurrency features from [Agent](https://github.com/igrigorik/agent) to [Pacer](https://github.com/pangloss/pacer).

For more information on Agent, check out this great blog post on
[Concurrency with Actors, Goroutines &amp; Ruby](http://www.igvita.com/2010/12/02/concurrency-with-actors-goroutines-ruby/).

## Project status

This is currently more of a proof of concept or spike than an actual
production-ready implementation. Only TinkerGraph elements are actually
serializable right now so, so using this with other element types will
probably work rather poorly.

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

