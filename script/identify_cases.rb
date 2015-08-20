#!/usr/bin/env ruby

require 'json'

require 'httpi'

require 'spreadsheet'


HOST = "***REMOVED***"
RELEVANT_FIELDS = [
  ["bfdnod", "efolder_nod"],
  ["bfd19", "efolder_form9"],
  ["bfdsoc", "efolder_soc"],
  ["bfssoc1", "efolder_ssoc1"],
  ["bfssoc2", "efolder_ssoc2"],
  ["bfssoc3", "efolder_ssoc3"],
  ["bfssoc4", "efolder_ssoc4"],
  ["bfssoc5", "efolder_ssoc5"],
]

def main(argv)
  if argv.length != 3
    $stderr.puts "identify_cases.rb <input-file> <good-output-file> <bad-output-file>"
    exit(1)
  end
  input_file, good_output_file, bad_output_file = argv

  good = []
  bad = []

  case_ids = extract_case_ids(file)
  case_ids.each do |case_id|
    if check_case_status(case_id)
      good << case_id
    else
      bad << case_id
    end
  end
  puts "There were #{good.length} good records and #{bad} bad records."

  good_sheet = create_spreadsheet(good)
  bad_sheet = create_spreadsheet(bad)

  good_sheet.write(good_output_file)
  bad_sheet.write(bad_output_file)
end

def extract_case_ids(input_file_name)
  case_ids = []
  Spreadsheet.open(file) do |workbook|
    workbook.worksheet(0).each do |row|
      case_ids << row[0]
    end
  end
  return case_ids
end

def check_case_status(case_id)
  request = HTTPI::Request.new("#{HOST}caseflow/api/certifications/start/#{case_id}")
  response = HTTPI.get(request)
  if response.code != 200
    raise "HTTP Error: #{response.status_code}"
  end
  data = JSON.parse(response.body)["info"]

  return RELEVANT_FIELDS.all? do |vacols_field, vbms_field|
    data[vacols_field] == data[vbms_field]
  end
end

def create_spreadsheet(case_ids)
  workbook = Spreadsheet::Workbook.new()
  sheet = workbook.create_worksheet()
  case_ids.each_with_index do |case_id, idx|
    sheet[idx, 0] = case_id
  end
  return workbook
end

if __FILE__ == $0
  main(ARGV)
end
