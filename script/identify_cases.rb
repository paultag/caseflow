#!/usr/bin/env ruby

require 'csv'
require 'json'

require 'parallel'


RELEVANT_FIELDS = [
  ["bfdnod_date", "efolder_nod_date", "NOD"],
  ["bfd19_date", "efolder_form9_date", "Form 9"],
  ["bfdsoc_date", "efolder_soc_date", "SOC"],
  ["bfssoc1_date", "efolder_ssoc1_date", "SSOC1"],
  ["bfssoc2_date", "efolder_ssoc2_date", "SSOC2"],
  ["bfssoc3_date", "efolder_ssoc3_date", "SSOC3"],
  ["bfssoc4_date", "efolder_ssoc4_date", "SSOC4"],
  ["bfssoc5_date", "efolder_ssoc5_date", "SSOC5"],
]

# Copied from conrrunt-ruby's 1.0 pre-release
class ConcurrentArray < ::Array
  include JRuby::Synchronized
end

def main(argv)
  if argv.length != 3
    $stderr.puts "identify_cases.rb <input-file> <good-output-file> <bad-output-file>"
    exit(1)
  end
  input_file, good_output_file, bad_output_file = argv

  if !input_file.end_with?(".csv")
    $stderr.puts "input-file must be a CSV"
    exit(1)
  end

  good = ConcurrentArray.new
  bad = ConcurrentArray.new

  case_ids = extract_case_ids(input_file)
  puts "Extracted #{case_ids.length} records from the input file."
  Parallel.each(case_ids, :in_threads => 8) do |case_id|
    status = check_case_status(case_id)
    if status.nil?
      good << case_id
    else
      bad << [case_id, status]
    end
  end
  puts "There were #{good.length} good records and #{bad.length} bad records."

  good_sheet = create_spreadsheet(good) do |case_id|
    [case_id[0]]
  end
  bad_sheet = create_spreadsheet(bad) do |case_id, fields|
    [case_id[0], "Unmatched fields: #{fields.join(', ')}"]
  end

  File.write(good_output_file, good_sheet)
  File.write(bad_output_file, bad_sheet)
end

def extract_case_ids(input_file_name)
  # The format of the spreadsheet is: [
  #   Appeal ID,
  #   LAST NAME,
  #   FIRST NAME,
  #   SENT TO BVA,
  #   STATUS,
  #   RO,
  #   Form 9,
  #   NOD,
  #   SOC,
  #   Certified,
  #   Total days,
  #   VBMS,
  # ]
  case_ids = []
  CSV.open(input_file_name) do |csv|
    csv.drop(1).each do |row|
      case_ids << [row[0], Date.strptime(row[6], '%m/%d/%Y')]
    end
  end
  return case_ids
end

def check_case_status(case_id)
  veteran_id, form_9_date = case_id
  c = Case.where(bfcorlid: veteran_id, bfd19: form_9_date).first
  if c.nil?
    raise "No cases found where(bfcorlid: #{veteran_id}, bfd19: #{form_9_date})"
  end

  bad_fields = RELEVANT_FIELDS.select do |vacols_field, vbms_field|
    c.send(vacols_field) != c.send(vbms_field)
  end

  if bad_fields.empty?
    return nil
  else
    return bad_fields.map { |_, _, field_name| field_name }
  end
end

def create_spreadsheet(rows)
  CSV.generate do |csv|
    rows.each do |row|
      csv << (yield row)
    end
  end
end

if __FILE__ == File.expand_path($0)
  main(ARGV)
end
