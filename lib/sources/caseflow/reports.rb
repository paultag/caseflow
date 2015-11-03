#!/usr/bin/env ruby

require 'csv'

require 'parallel'


module Caseflow
  # Copied from conrrunt-ruby's 1.0 pre-release
  class ConcurrentArray < ::Array
    include JRuby::Synchronized
  end

  class SeamReport
    def find_vacols_cases
      return Case.joins(:folder).where(
        "bf41stat IS NOT NULL and bfmpro = ? AND folder.tivbms NOT IN (?)",
        "ADV", ["Y", "1", "0"]
      )
    end

    def should_include(vacols_case)
      vacols_case.efolder_case.documents.length >= 1
    end

    def spreadsheet_columns
      ["BFKEY", "TYPE", "TIVBMS", "AOJ"]
    end

    def spreadsheet_cells(vacols_case)
      # TODO: add data on mismatched dates between VACOLS and VBMS
      [vacols_case.bfkey, vacols_case.bfac, vacols_case.folder.tivbms, vacols_case.regional_office_full]
    end
  end

  class MismatchedDocumentsReport
    def find_vacols_cases
      return Case.joins(:folder).where(
        "bf41stat IS NOT NULL and bfmpro = ? AND folder.tivbms IN (?)",
        "ADV", ["Y", "1", "0"]
      )
    end

    def should_include(vacols_case)
      !vacols_case.ready_to_certify?
    end

    def spreadsheet_columns
      ["BFKEY", "TYPE", "AOJ"]
    end

    def spreadsheet_cells(vacols_case)
      # TODO: add data on mismatched dates between VACOLS and VBMS
      [vacols_case.bfkey, vacols_case.bfac, vacols_case.regional_office_full]
    end
  end

  REPORTS = {
    "seam" => SeamReport,
    "mismatched" => MismatchedDocumentsReport,
  }
end

def create_spreadsheet(report, items)
  CSV.generate do |csv|
    csv << report.spreadsheet_columns
    items.each do |item|
      csv << report.spreadsheet_cells(item)
    end
  end
end

def main(argv)
  # Trigger autoloading of this case because reasons. I don't even sometimes.
  EFolder::Case

  if argv.length != 2
    $stderr.puts "reports.rb <report-name> <output.csv>"
    exit(1)
  end

  report_name, output_path, = argv

  if !Caseflow::REPORTS.has_key?(report_name)
    $stderr.puts "Unknown report"
    exit(1)
  end

  if !output_path.ends_with?(".csv")
    $stderr.puts "output file must end in .csv"
    exit(1)
  end

  report = Caseflow::REPORTS[report_name].new

  vacols_cases = report.find_vacols_cases().to_a
  puts "Found #{vacols_cases.length} relevant cases in VACOLS"
  report_cases = Caseflow::ConcurrentArray.new
  Parallel.each(vacols_cases, in_threads: 8) do |vacols_case|
    if report.should_include(vacols_case)
      report_cases << vacols_case
    end
  end

  puts "Found #{report_cases.length} cases that met the report conditions"

  sheet = create_spreadsheet(report, report_cases)
  File.write(output_path, sheet)
end

if __FILE__ == $0
  main(ARGV)
end
