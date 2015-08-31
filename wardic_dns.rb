#!/usr/bin/env ruby

# Author: Christian Fernandez 2015
# Email: http://hispagatos http://binaryfreedom
# Description:
#   Finds the subnets of a domain name using a bruteforce dictionary attack.
#   This program is capable of saving a log of the subnets it produces.

require 'dnsruby'
require 'docopt'

doc=<<DOCOPT

Searches for DNS subnets and sends output to STDOUT. Select verbose to get
more complete error messages.

Usage:
  #{File.basename __FILE__} <domain_name> [options]
  #{File.basename __FILE__} <domain_name> [-v | --verbose]
  #{File.basename __FILE__} <domain_name> [-l <log> | --log <log>]
  #{File.basename __FILE__} <domain_name> [-d <dict> | --dictionary <dict>]
  #{File.basename __FILE__} -h | --help

Options:
  -h, --help              Display this message
  -l, --log <log>         Save a log to location and silence stdout.
  -d, --dictionary <dict> Set custom dictionary.
  -v, --verbose           Verbose output.
  -q, --quiet             Quiet output.

  Default dictionary is './dictionary'.
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
      $stdout.puts "#{line}.#{domain} exists."
      log_file.puts "#{line}.#{domain}"
      sleep 1
    rescue Dnsruby::ResolvError
      $stderr.puts "#{line}.#{domain} D.N.E" if args["--verbose"]
      log_file.puts  "#{line}.#{domain} D.N.E" if args["--verbose"]
    rescue Dnsruby::ResolvTimeout
      log_file.puts "timeout"
    end
  end
end
