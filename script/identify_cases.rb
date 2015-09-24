#!/usr/bin/env ruby

require 'csv'
require 'json'

require 'parallel'

require 'spreadsheet'


RELEVANT_FIELDS = [
  ["bfdnod", "efolder_nod", "NOD"],
  ["bfd19", "efolder_form9", "Form 9"],
  ["bfdsoc", "efolder_soc", "SOC"],
  ["bfssoc1", "efolder_ssoc1", "SSOC1"],
  ["bfssoc2", "efolder_ssoc2", "SSOC2"],
  ["bfssoc3", "efolder_ssoc3", "SSOC3"],
  ["bfssoc4", "efolder_ssoc4", "SSOC4"],
  ["bfssoc5", "efolder_ssoc5", "SSOC5"],
]

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

  good = []
  bad = []

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
    [case_id]
  end
  bad_sheet = create_spreadsheet(bad) do |case_id, fields|
    [case_id, "Unmatched fields: #{fields.join(', ')}"]
  end

  good_sheet.write(good_output_file)
  bad_sheet.write(bad_output_file)
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
      case_ids << [row[0], Date.strptime(row[6], '%m/%d/%y')]
    end
  end
  return case_ids
end

def check_case_status(h, case_id)
  veteran_id, form_9_date = case_id
  c = Case.where(bfcorlid: veteran_id, bfd19: form_9_date).first
  if c.nil?
    raise "No cases found where(bfroflid: #{veteran_id}, bfd19: #{form_9_date})"
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
  workbook = Spreadsheet::Workbook.new()
  sheet = workbook.create_worksheet()
  rows.each_with_index do |row, idx|
    columns = yield row
    columns.each_with_index do |col, col_num|
      sheet[idx, col_num] = col
    end
  end
  return workbook
end

if __FILE__ == File.expand_path($0)
  main(ARGV)
end
