wardic_dns - War dictionary attack on DNS
=========================================

Description
-----------

Wardic_DNS is a DNS subnet dictionary bruteforce attack in Ruby. The program
will will find subnet matches on a domain based on a dictionary file. A sample
dictionary is provided with common subnet names. 

Check out "rockyou.txt" or provide your own dictionary for a more through
sweep.

Installation
------------

You will need to manually install the dependancies for this program to work
correctly.

### Dependencies

This script relies on Docopt to parse command line arguements and Dnsruby to
resolve DNS queries.

```
gem install dnsruby
gem install docopt
```

### GitHub

Download the most recent version from GitHub.

```
git clone https://github.com/ChrisFernandez/wardic_dns.git
```

Contribute
----------

This project is currently just a proof of concept in Ruby. Feel free to fork
and submit your changes back.

LICENSE
-------

Licensed under the GPLv3. For additional details see the LICENSE provided in
the repository.
