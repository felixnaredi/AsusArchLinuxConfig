#!/usr/bin/env ruby
#
# Date: 2018-04-23 16:30:30 +0200
# Author: Felix Naredi
#

unless ARGV.length > 0
  puts "USAGE:\n  fxpdf [FILES...]"
  return
end

system "firefox -new-tab #{ARGV.join ' '}"


