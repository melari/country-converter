#!/usr/bin/env ruby
require 'terrun'
require 'yaml'

class CountryConverter < TerminalRunner
  name "country-converter"

  param "input", "A file containing the list of countries to convert."

  option "--help", 0, "", "Shows this help file."
  option "--name", 0, "", "Output the country name instead of code."

  option_alias "--help", "-h"
  option_alias "--name", "-n"

  help <<-EOS
    There should be one country name per line in the input file.
    By default the converter goes from name >> code, this can be changed by including the --name flag.
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

    if @@options.include? "--name"
      input = "code"
      output = "name"
    else
      input = "name"
      output = "code"
    end

    codes = []
    File.open(@@params["input"], "r") do |infile|
      while (line = infile.gets)
        line = line[0..-2]
        codes << self.find_country(line, input, output)
      end
    end
    puts codes.join(", ")
  end

  def self.find_country(name, input, output)
    @@countries.each do |country|
      return country[output] if (country[input] == name)
    end
    "[#{name} - NOT FOUND]"
  end
end

if __FILE__ == $0
  x = CountryConverter.start(ARGV)
end
