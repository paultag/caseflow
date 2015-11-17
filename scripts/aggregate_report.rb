#!/usr/bin/env ruby

require 'csv'


def group_by_csv_field(path, field)
  by_field = Hash.new(0)
  CSV.foreach(path, headers: true) do |row|
    by_field[row.field(field)] += 1
  end
  by_field.to_a.sort_by{|c| c[1]}
end

def group_by_vacols_date(path, field)
  bfkeys = []
  CSV.foreach(path, headers: true) do |row|
    bfkeys << row.field("BFKEY")
  end

  cases = []
  # ORACLE does not allow queries with more than 1000 parameters
  bfkeys.each_slice(500) do |bfs|
    cases.concat Case.where(bfkey: bfs)
  end

  by_field = Hash.new(0)
  cases.each do |c|
    case field
    when "nod"
      col = c.bfdnod
    when "form9"
      col = c.bfd19
    end
    by_field[col.strftime("%Y-%m")] += 1
  end
  by_field.to_a.sort_by{|c| c[0]}
end

def main(argv)
  if argv.length != 2
    $stderr.puts "Usage: aggregate_report.rb <path> <CSV-field-name>"
    exit(1)
  end

  path, field = argv

  case field
  when "nod", "form9"
    by_field = group_by_vacols_date(path, field)
  else
    by_field = group_by_csv_field(path, field)
  end

  header = "#{path} grouped by #{field}"
  puts header
  puts "=" * header.length
  puts

  by_field.each do |c|
    puts "#{c[0]} - #{c[1]}"
  end
end

if __FILE__ == $0
  main(ARGV)
end
