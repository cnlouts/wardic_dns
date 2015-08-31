#!/usr/bin/env ruby

# Author: Christian Fernandez 2015
# Email: http://hispagatos http://binaryfreedom
# Description:
#   Finds the subnets of a domain name provided using a dictionary.
#   This program is capable of saving a log of the subnets it produces.

require 'dnsruby'
require 'docopt'

doc=<<DOCOPT

Searches for DNS subnets and sends output to STDOUT. Sends logs to STDERR
by default or to a user provided logfile.

Usage:
  #{File.basename __FILE__} <domain_name> [options]
  #{File.basename __FILE__} <domain_name> [-v | --verbose | -q | --quiet]
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
log_file = args["--log"] ? File.open(args["--log"], mode="a") : $stderr
dict_filename = args["--dictionary"] ? args["--dictionary"] : "dictionary"

File.open(dict_filename, mode="r") do |f|
  res = Dnsruby::Resolver.new
  f.each_line do |line|
    line = line.strip
    begin
      res.query("#{line}.#{domain}", "A")
      $stdout.puts "#{line}.#{domain}" unless args["--quiet"]
      sleep 1
    rescue Dnsruby::ResolvError
      log_file.puts  "#{line}.#{domain} does not exist" if args["--verbose"]
    rescue Dnsruby::ResolvTimeout
      log_file.puts "timeout"
    end
  end
end
