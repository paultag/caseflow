#!/usr/bin/env ruby

require 'csv'


def main(argv)
  if argv.length != 2
    $stderr.puts "Usage: aggregate_report.rb <path> <CSV-field-name>"
    exit(1)
  end

  path, field = argv

  by_field = Hash.new(0)
  CSV.foreach(path, headers: true) do |row|
    by_field[row.field(field)] += 1
  end

  header = "#{path} grouped by #{field}"
  puts header
  puts "=" * header.length
  puts

  by_field.to_a.sort_by{|c| c[1]}.each do |c|
    puts "#{c[0]} - #{c[1]}"
  end
end

if __FILE__ == $0
  main(ARGV)
end
