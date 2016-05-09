# Treefell [![Build Status](https://travis-ci.org/zdennis/treefell.svg?branch=master)](https://travis-ci.org/zdennis/treefell)

> If a tree falls in a forest and no one is around to hear it, does it make a sound?

Treefell is a minimalist debug-logging library for ruby. It uses the DEBUG environment variable to determine which debug messages are logged and which are suppressed.

This project was inspired by visionmedia's [debug](https://github.com/visionmedia/debug) library for nodejs. 

## Installation

Add this line to your application's Gemfile:

    gem 'treefell'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install treefell

## Usage

Take the ruby program:

```ruby
#!/usr/bin/env ruby

require 'treefell'

foo_debug = Treefell['foo']
foo_debug.puts 'too funky in here'

bar_debug = Treefell['bar']
bar_debug.puts 'you got that right'

baz_debug = Treefell['baz']
baz_debug.puts 'say it again'
```

Each call to `Treefell['...']` instantiates a `DebugLogger` for the provided
namespace (e.g. foo, bar, baz).

By default no debug log statements are displayed:

```
> ruby program.rb
```

### Displaying all messages

You can tell it to display all messages with the wildcard `*`:

![Example 1 Screenshot](/examples/example_1.png?raw=true)

### Displaying messages from a particular namespace

Here's how to display messages for one specific debugging namespace:

![Example 2 Screenshot](/examples/example_2.png?raw=true)

### Displaying messages for multiple namespaces

To display messages from multiple namespaces use a comma-separated list of
namespaces:

![Example 3 Screenshot](/examples/example_3.png?raw=true)

### Colored output

Every namespace gets a color associated with it to aide in the visual parsing
of the output. Also `DebugLogger`(s) are cached per namespace so regardless
of when you refer to the namespace it will always have the same color
associated with it.

E.g.

```ruby
foo_debug = Treefell['foo']
other_foo_debug = Treefell['foo']

foo_debug.eql?(other_foo_debug) # => true
```

#### Sending to IO other than STDOUT

By default all messages are written to `STDOUT`. You can change this by
instantiating a debug logger using the `debug` method, e.g.:

```ruby
foo_debug = Treefell.debug('foo', io: some_io)
foo_debug.puts 'Get up offa that thing, and dance till you feel better'
```

## Contributing

1. Fork it ( https://github.com/zdennis/treefell/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
