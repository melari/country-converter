#!/usr/bin/env ruby
require 'terrun'
require 'yaml'

class CountryConverter < TerminalRunner
  name "country-converter"

  param "input", "A file containing the list of countries to convert."

  option "--help", 0, "", "Shows this help file."
  option_alias "--help", "-h"

  help <<-EOS
    There should be one country name per line in the file.
  EOS

  def self.run
    if @@options.include? "--help"
      show_usage
      exit
    end

    unless File.exists? @@params["input"]
      puts "Cannot find input file '#{@@params["input"]}'"
      exit
    end

    @@countries = YAML::load_file("countries.yml")

    codes = []
    File.open(@@params["input"], "r") do |infile|
      while (line = infile.gets)
        line = line[0..-2]
        codes << self.find_country(line)
      end
    end
    puts codes.join(", ")
  end

  def self.find_country(name)
    @@countries.each do |country|
      return country["code"] if (country["name"] == name)
    end
    "[#{name} - NOT FOUND]"
  end
end

if __FILE__ == $0
  x = CountryConverter.start(ARGV)
end
