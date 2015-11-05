#!/usr/bin/env ruby

require 'csv'

require 'parallel'


module Caseflow
  # Copied from conrrunt-ruby's 1.0 pre-release
  module Reports
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

    class ConcurrentArray < ::Array
      include JRuby::Synchronized
    end

    def self.mismatched_dates(c)
      mismatched_fields = RELEVANT_FIELDS.select do |vacols_field, vbms_field|
        c.send(vacols_field) != c.send(vbms_field)
      end
      mismatched_fields.map {|_, _, field_name| field_name }.join(", ")
    end

    def self.hearing_pending(c)
      # bfhr: Hearing requested ("1" -> Central Office, "2" -> Travel Board)
      # bfha: Hearing action (NULL -> No hearing happened)
      if (c.bfhr == "1" || c.bfhr == "2") && c.bfha.nil?
        "Y"
      else
        "N"
      end
    end

    TYPE_ACTION = {
      "1" => "1-Original",
      "2" => "2-Supplemental",
      "3" => "3-Post-remand",
      "4" => "4-Reconsideration",
      "5" => "5-Vacate",
      "6" => "6-De novo",
      "7" => "7-Court remand",
      "8" => "8-DOR",
      "9" => "9-CUE",
      "P" => "P-Post decision development",
    }

    class SeamReport
      def find_vacols_cases
        return Case.joins(:folder).where(
          "bf41stat IS NOT NULL and bfmpro = ? AND (folder.tivbms IS NULL OR folder.tivbms NOT IN (?))",
          "ADV", ["Y", "1", "0"]
        )
      end

      def should_include(vacols_case)
        vacols_case.efolder_case.documents.length >= 1
      end

      def spreadsheet_columns
        ["BFKEY", "TYPE", "FILE TYPE", "AOJ", "MISMATHCED DATES", "CERT DATE", "HAS HEARING PENDING"]
      end

      def spreadsheet_cells(vacols_case)
        [
          vacols_case.bfkey,
          TYPE_ACTION[vacols_case.bfac],
          vacols_case.folder.file_type,
          vacols_case.regional_office_full,
          Caseflow::Reports.mismatched_dates(vacols_case),
          vacols_case.bf41stat,
          Caseflow::Reports.hearing_pending(vacols_case)
        ]
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
        ["BFKEY", "TYPE", "AOJ", "MISMATHCED DATES"]
      end

      def spreadsheet_cells(vacols_case)
        [
          vacols_case.bfkey,
          TYPE_ACTION[vacols_case.bfac],
          vacols_case.regional_office_full,
          Caseflow::Reports.mismatched_dates(vacols_case),
        ]
      end
    end
  end

  REPORTS = {
    "seam" => Reports::SeamReport,
    "mismatched" => Reports::MismatchedDocumentsReport,
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

  # For now only process cases whose bfcorlid is an SSN
  vacols_cases = vacols_cases.reject { |c| !c.bfcorlid.ends_with?("S") || c.efolder_appellant_id.length != 9 }
  puts "#{vacols_cases.length} cases with potential eFolder IDs"

  report_cases = Caseflow::Reports::ConcurrentArray.new
  Parallel.each(vacols_cases, in_threads: 4, progress: "Checking VBMS") do |vacols_case|
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
