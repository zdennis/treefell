#!/usr/bin/env ruby

require 'treefell'

foo_debug = Treefell['foo']
foo_debug.puts 'too funky in here'

bar_debug = Treefell['bar']
bar_debug.puts 'you got that right'

baz_debug = Treefell['baz']
baz_debug.puts 'say it again'
