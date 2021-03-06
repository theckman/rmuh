RMuh
====
[![Build Status](https://img.shields.io/travis/theckman/rmuh/master.svg)](https://travis-ci.org/theckman/rmuh)
[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://tldrlegal.com/license/mit-license)
[![RubyGems :: RMuh Gem Version](http://img.shields.io/gem/v/rmuh.svg)](https://rubygems.org/gems/rmuh)
[![Coveralls Coverage](https://img.shields.io/coveralls/theckman/rmuh/master.svg)](https://coveralls.io/r/theckman/rmuh)
[![Code Climate](https://img.shields.io/codeclimate/github/theckman/rmuh.svg)](https://codeclimate.com/github/theckman/rmuh)
[![Gemnasium](https://img.shields.io/gemnasium/theckman/rmuh.svg)](https://gemnasium.com/theckman/rmuh)

**NOTICE**: UnitedOperations has dropped support for ArmA 2. So as of now, this
project should be considered no longer maintained. Due to this tests are also
failing, so Travis CI has been disabled by renaming the `.travis.yml` file to
`.travis.yml.disabled`

**RMuh**, a play on the name ArmA (Armed Assault), is a Ruby library for
interacting with ArmA 2 servers (specifically tested against Operation
Arrowhead servers).

LICENSE
-------
**RMuh** is released under the
[The MIT License](http://opensource.org/licenses/MIT). The full text of the
license can be found in the `LICENSE` file. The summary can be found
[here](https://tldrlegal.com/license/mit-license#summary) courtest of
tldrlegal.

In short, MIT is a permissive license and means you can pretty much do what you
want with this code as long as the original copyright is included.

CONTRIBUTING
------------
I know different communities may have slightly different RPT/Server log files.
Want to contribute changes/additions to the project? Just for the project to
your own repo, make your changes and write corresponding RSpec tests, and then
submit a PR.

INSTALLATION
------------
This is packaged on the [RubyGems](https://rubygems.org/) site and can be
installed via the `gem` command:

```Bash
$ gem install rmuh
```

If you have a `Gemfile` or a `Gemspec` file for your project you can add
these entires to these files and use `bundle install` to install the gem:

**Gemfile**:

```Ruby
gem 'rmuh'
```

**Gemspec**:

```Ruby
Gem::Specification.new do |g|
  # ...
  g.add_runtime_dependency 'rmuh'
  # ...
end
```

**Note:** If you want to do version pinning within your `Gemfile` or `Gemspec`
file visit [RubyGems :: RMuh](https://rubygems.org/gems/rmuh) to see the
specific versions available.

USAGE
-----
This is just an overview of how to use the specific features of `RMuh`. For
full documentation please view the `README.md` files within the `lib` dir,
look in the `examples` dir, or visit the docs on
[RubyDoc](http://rubydoc.info/gems/rmuh).

So here are some examples of how to use the different classes.

Log Fetching
------------
There is a built in log fetcher that uses `httparty` to pull the log files.

Here is an example of how to just fetch the full log and print it:

```Ruby
require 'rmuh/rpt/log/fetch'
URL = 'http://arma2.unitedoperations.net/dump/SRV1/SRV1_RPT.txt'
f = RMuh::RPT::Log::Fetch.new(URL)
puts f.log
```
In this case `f.log` returns an `Array` object which will be used by the
parsers to parse the log files.

If you want to specify a
[byte range](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35.2):

```Ruby
f = RMuh::RPT::Log::Fetch.new(URL, byte_start: 100, byte_end: 200)
```
This can be used to pull the log in smaller sizes if you are doing incremental
updates. To compound the byte range ability, you can get the log file size as
well as update the byte range after initializing the object:

```Ruby
f.size            # prints Fixnum
f.byte_start = 10 # Sets the first byte to 10
f.byte_end = 40   # Sets the last byte to 40
```

Log Parsing
-----------
Included with this module is a default log parser. The default parser does
nothing but return each line as a Hash within an Array. There is no metadata
extracted, it's a literal copy and paste of the provided log line. This default
parser is primarily used as an example class to be used for subclassing of your
own parser.

```Ruby
require 'rmuh/rpt/log/fetch'
require 'rmuh/rpt/parsers/base'
URL = 'http://arma2.unitedoperations.net/dump/SRV1/SRV1_RPT.txt'
f = RMuh::RPT::Log::Fetch.new(URL)
p = RMuh::RPT::Log::Parsers::Base.new
l = p.parse(f.log)
```
At this specific moment `l` would contain an Array of Hashes corresponding to
the log lines.

Log Formatting
--------------
There are also built-in formatters that allow you to dump the events to a
format similar to the original log lines. They were changed a bit to be more
readable and relevant.

The formatters just take an event and return a String. Assuming `event` is a
single valid event here:

```Ruby
require 'rmuh'
puts RMuh::PRT::Log::Formatters::UnitedOperationsRPT.format(event)
```

Server Stats
------------
The `RMuh` gem also wraps the
[GamespyQuery](https://rubygems.org/gems/gamespy_query) Rubygem for pulling
live statistics from the server. This includes current map, mission, play list,
and others. Deep down this just uses the GameSpy protocol to get the
information directly from the server.

### Future Functionality Note

As of ArmA 2: Operation Arrowhead version `1.63` this is no longer
working. This is due to GameSpy being shut down, and removed from ArmA 2 by
Bohemia Interactive as part of
[ArmA 2:OA Update 1.63](http://www.arma2.com/latest-news/arma-2-operation-arrowhead-update-163).
Beyond the [Bohemia Interactive server list](http://master.bistudio.com/)
there are no known alternatives to getting this information at the time of writing.

*well fuck...*

So, if you have an A2:OA server older than `1.63` (e.g., version `1.62`),
here is a quick overview of how to use this functionality:

```Ruby
require 'rmuh/serverstats/base'
UO_IP = '70.42.74.59'
s = RMuh::ServerStats::Base.new(host: UO_IP)
puts s.stats
```
By default the `ServerStats::Base` class caches the information so you need to
explicitly update the cache. This is not done automatically as it is a blocking
operation, this allow you to block somewhere other than where you instantiate
the object.

If you want to avoid using the cache:

```Ruby
s = RMuh::ServerStats::Base.new(host: UO_IP, cache: false)
```
If you want to be able to pull each part of the returned data set using
dot-notation, you can use the `Advanced` class:

```Ruby
require 'rmuh/serverstats/base'
s = RMuh::ServerStats::Advanced.new(host: UO_IP)
puts s.players
```
In this case, `players` is an Array. If you specify a key that doesn't exist
you will get a NoMethodError exception.

SUPPORT
-------
Having some problems understanding something? Just open an issue and I'll get
back to you as soon as I can.
