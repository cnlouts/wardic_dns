#!/usr/bin/env ruby
#gem install OptionParser
#gem install dnsruby

require 'dnsruby'
include Dnsruby
require 'optparse'



ARGV << '-h' if ARGV.empty?
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: dns_scan.rb [options]"
  opts.on('-d', '--domain binaryfreedom.info', 'Domain name') do |d|
    options[:domain] = d;
  end
  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end.parse!


domain = options[:domain]

data = File.open("dictionary")
res = Resolver.new

until data.eof()
   line = data.readline().strip
   begin
     response  = res.query("#{line}.#{domain}", "A")
     puts "#{line}.#{domain} !!!!!!"
   rescue ResolvError
     #puts "#{line} do not exist"
   rescue ResolvTimeout
     puts "timeout"
   end
end
