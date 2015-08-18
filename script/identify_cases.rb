#!/usr/bin/env ruby

require 'json'

require 'httpi'

require 'spreadsheet'


HOST = "***REMOVED***"
RELEVANT_FIELDS = [
  [:bfdnod, :efolder_nod],
  [:bfd19, :efolder_form9],
  [:bfdsoc, :efolder_soc],
  [:bfssoc1, :efolder_ssoc1],
  [:bfssoc2, :efolder_ssoc2],
  [:bfssoc3, :efolder_ssoc3],
  [:bfssoc4, :efolder_ssoc4],
  [:bfssoc5, :efolder_ssoc5],
]

def main(argv)
  file, = argv

  good = []
  bad = []
  Spreadsheet.open(file).worksheet(0).each do |row|
    case_id = row[0]

    request = HTTPI::Request.new("#{HOST}caseflow/api/certifications/start/#{case_id}")
    response = HTTPI.get(request)
    assert response.code == 200
    data = JSON.parse(response.body)[:info]

    matching = RELEVANT_FIELDS.all? do |vacols_field, vbms_field|
      data[vacols_field] == data[vbms_field]
    end
    if matching
      good << case_id
    else
      bad << case_id
    end
  end

  puts "There were #{good.length} good records and #{bad} bad records."
end

if __FILE__ == $0
  main(ARGV)
end
