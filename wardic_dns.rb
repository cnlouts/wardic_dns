#!/usr/bin/env ruby

# Author: Christian Fernandez 2015
# Email: http://hispagatos http://binaryfreedom
# Description:
#   Finds the subnets of a domain name using a bruteforce dictionary attack.
#   This program is capable of saving a log of the subnets it produces.

require 'dnsruby'
require 'docopt'
require 'pathname'

doc=<<DOCOPT

Searches for DNS subnets and sends output to STDOUT. Verbose prints domain
entries that do not exist. Default dictionary location is './dictionary'.

Usage:
  #{__FILE__} <domain_name> [-v | -q] [--log=<log>] [--dictionary=<dict>]
  #{__FILE__} -h | --help
Options: 
  --log=<log>             Save a log to file.
  --dictionary=<dict>     Set custom dictionary.
  -v                      Verbose output.
  -q                      Quiet output.
  -h, --help              Display this message 
DOCOPT

args = {}
begin
  args = Docopt::docopt(doc)
rescue Docopt::Exit => e
  puts e.message
  exit 1
end

domain = args["<domain_name>"]
log_file = File.open(args["--log"], mode="a") if args["--log"] 
dict_filename = args["--dictionary"] ? args["--dictionary"] : "dictionary"

File.open(dict_filename, mode="r") do |f|
  res = Dnsruby::Resolver.new
  f.each do |line|
    line = line.strip
    begin
      res.query("#{line}.#{domain}", "A")
      $stdout.puts "#{line}.#{domain}" unless args["-q"]
      log_file.puts "#{line}.#{domain}" if args["--log"]
      sleep 1
    rescue Dnsruby::ResolvError
      if args["-v"]
        $stderr.puts "#{line}.#{domain} D.N.E"
        log_file.puts "#{line}.#{domain} D.N.E" if args["--log"]
      end
    rescue Dnsruby::ResolvTimeout
      $stderr.puts "Timeout." unless args["-q"]
      log_file.puts "Timeout." if args["--log"]
    end
  end
end
