#!/usr/bin/env ruby

require 'csv'
require 'optparse'
require 'set'

require 'parallel'


module Caseflow
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
    # 3 days
    ALTERNATIVE_AGE_THRESHOLD = 3 * 24 * 60 * 60

    class ConcurrentCSV < ::CSV
      include JRuby::Synchronized
    end

    def self.mismatched_dates(c)
      mismatched_fields = RELEVANT_FIELDS.select do |vacols_field, vbms_field|
        c.send(vacols_field) != c.send(vbms_field)
      end
      mismatched_fields.map {|_, _, field_name| field_name }.join(", ")
    end

    def self.potential_date_alternatives(c)
      alternatives = []
      mismatched_docs = mismatched_dates(c)
      [
        ["NOD", :bfdnod, EFolder::Case::NOD_DOC_TYPE_ID],
        ["Form 9", :bfd19, EFolder::Case::FORM_9_DOC_TYPE_ID],
      ].each do |name, field, type_id|
        if mismatched_docs.include?(name)
          alt = c.efolder_case.documents.detect do |doc|
            # Do we have an NOD from within 3 days of what VACOLS shows?
            doc.doc_type.try(:to_i) == type_id && doc.received_at &&
              (doc.received_at.beginning_of_day - c.send(field).beginning_of_day).to_i < ALTERNATIVE_AGE_THRESHOLD
          end

          if !alt.nil?
            days = (alt.received_at.beginning_of_day - c.send(field).beginning_of_day) / 86400
            alternatives << "#{name}: #{'+' if days > 0}#{days.to_i} day#{'s' if days.abs > 1}"
          end
        end
      end

      alternatives
    end

    def self.potential_label_alternatives(c)
      alternative_doc_types = {
        EFolder::Case::STATEMENT_IN_SUPPORT_OF_CLAIM_DOC_TYPE_ID => "VA 21-4138 Statement In Support of Claim",
        EFolder::Case::THIRD_PARTY_CORRESPONDENCE_DOC_TYPE_ID => "Third Party Correspondence",
        EFolder::Case::CORRESPONDENCE_DOC_TYPE_ID => "Correspondence",
      }

      alternatives = []
      mismatched_docs = mismatched_dates(c)
      [["NOD", :bfdnod], ["Form 9", :bfd19]].each do |name, field|
        if mismatched_docs.include?(name)
          alt = c.efolder_case.documents.detect do |doc|
            alternative_doc_types.include?(doc.doc_type.try(:to_i)) &&
              doc.received_at.try(:beginning_of_day) == c.send(field).beginning_of_day
          end

          if !alt.nil?
            alternatives << "#{name}: #{alternative_doc_types[alt.doc_type.to_i]}"
          end
        end
      end

      alternatives
    end

    def self.bool_cell(value)
      if value
        "Y"
      else
        "N"
      end
    end

    def self.hearing_pending(c)
      # bfhr: Hearing requested ("1" -> Central Office, "2" -> Travel Board)
      # bfha: Hearing action (NULL -> No hearing happened)
      bool_cell((c.bfhr == "1" || c.bfhr == "2") && c.bfha.nil?)
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
      # Appeals from these sources are _always_ paper, even if the appelant has
      # an eFolder
      PAPER_ONLY_OFFICES = [
        # General Counsel
        "RO89",
        # Education Centers
        "RO91", "RO92", "RO93", "RO94",
        # Pension
        "RO80", "RO81", "RO82", "RO83",
        # VHA CO
        "RO99",
      ]

      def initialize
        # VBMS document types which are appeals related documents
        @appeals_document_types = [
          EFolder::Case::SOC_DOC_TYPE_ID,
          EFolder::Case::NOD_DOC_TYPE_ID,
          EFolder::Case::SSOC_DOC_TYPE_ID,
          EFolder::Case::FORM_9_DOC_TYPE_ID,
          EFolder::Case::FORM_8_DOC_TYPE_ID,
        ]
      end

      def find_vacols_cases
        return Case.joins(:folder).where(
          "bf41stat < ? AND bfmpro = ? AND (folder.tivbms IS NULL OR folder.tivbms NOT IN (?)) AND bfregoff NOT IN (?)",
          2.weeks.ago, "ADV", ["Y", "1", "0"], PAPER_ONLY_OFFICES
        )
      end

      def should_include(vacols_case)
        # Include cases in the report which have an appeals related document in
        # their eFolder
        vacols_case.efolder_case.documents.any? do |doc|
          @appeals_document_types.include?(doc.doc_type.try(:to_i))
        end
      end

      def spreadsheet_columns
        ["BFKEY", "TYPE", "FILE TYPE", "AOJ", "MISMATCHED DATES", "NOD DATE", "CERT DATE", "HAS HEARING PENDING", "CORLID", "IS MERGED"]
      end

      def spreadsheet_cells(vacols_case)
        [
          vacols_case.bfkey,
          TYPE_ACTION[vacols_case.bfac],
          vacols_case.folder.file_type,
          vacols_case.regional_office_full,
          Caseflow::Reports.mismatched_dates(vacols_case),
          vacols_case.bfdnod,
          vacols_case.bf41stat,
          Caseflow::Reports.hearing_pending(vacols_case),
          vacols_case.bfcorlid,
          Caseflow::Reports.bool_cell(vacols_case.merged?),
        ]
      end
    end

    class MismatchedDocumentsReport
      def find_vacols_cases
        return Case.joins(:folder).where(
          "bf41stat < ? AND bfmpro = ? AND folder.tivbms IN (?)",
          2.weeks.ago, "ADV", ["Y", "1", "0"]
        )
      end

      def should_include(vacols_case)
        !vacols_case.ready_to_certify?
      end

      def spreadsheet_columns
        ["BFKEY", "TYPE", "AOJ", "MISMATCHED DATES", "NOD DATE", "CERT DATE", "HAS HEARING PENDING", "CORLID", "IS MERGED", "POTENTIAL DATE ALTERNATIVES", "POTENTIAL LABEL ALTERNATIVES"]
      end

      def spreadsheet_cells(vacols_case)
        [
          vacols_case.bfkey,
          TYPE_ACTION[vacols_case.bfac],
          vacols_case.regional_office_full,
          Caseflow::Reports.mismatched_dates(vacols_case),
          vacols_case.bfdnod,
          vacols_case.bf41stat,
          Caseflow::Reports.hearing_pending(vacols_case),
          vacols_case.bfcorlid,
          Caseflow::Reports.bool_cell(vacols_case.merged?),
          Caseflow::Reports.potential_date_alternatives(vacols_case).join(", "),
          Caseflow::Reports.potential_label_alternatives(vacols_case).join(", "),
        ]
      end
    end
  end

  REPORTS = {
    "seam" => Reports::SeamReport,
    "mismatched" => Reports::MismatchedDocumentsReport,
  }
end


def main(argv)
  # Trigger autoloading of this case because reasons. I don't even sometimes.
  EFolder::Case

  concurrency = 1
  report_name = nil
  output_path = nil
  excluded_bfkeys = Set.new

  OptionParser.new do |opts|
    opts.banner = "Usage: reports.rb [--concurrency=n] [--exclusions=path] --report-name=<report-name> --output=<output.csv>"

    opts.on("--concurrency=[n]") do |c|
      concurrency = c.to_i
    end

    opts.on("--report-name=", Caseflow::REPORTS.keys) do |r|
      report_name = r
    end

    opts.on("--exclusions=") do |e|
      CSV.foreach(e, headers: true) do |row|
        excluded_bfkeys.add(row.field("BFKEY"))
      end
    end

    opts.on("--output=") do |o|
      if !o.ends_with?(".csv")
        $stderr.puts "output file must end in .csv"
        exit(1)
      end
      output_path = o
    end
  end.parse!

  if report_name.nil? || output_path.nil?
    $stderr.puts "Missing --report-name or --output"
    exit(1)
  end

  report = Caseflow::REPORTS[report_name].new

  vacols_cases = report.find_vacols_cases().to_a
  vacols_cases = vacols_cases.reject { |c| excluded_bfkeys.include?(c.bfkey) }
  puts "Found #{vacols_cases.length} relevant cases in VACOLS"

  # For now only process cases whose efolder_appellant_id's length is >= 8
  vacols_cases = vacols_cases.reject { |c| c.efolder_appellant_id.length < 8 }
  puts "#{vacols_cases.length} cases with potential eFolder IDs"

  Caseflow::Reports::ConcurrentCSV.open(output_path, "wb") do |csv|
    csv << report.spreadsheet_columns
    Parallel.each(vacols_cases, in_threads: concurrency, progress: "Checking VBMS") do |vacols_case|
      begin
        if report.should_include(vacols_case)
          Rails.logger.info "event=report.case.found bfkey=#{vacols_case.bfkey}"
          csv << report.spreadsheet_cells(vacols_case)
        else
          Rails.logger.info "event=report.case.condition_not_met bfkey=#{vacols_case.bfkey}"
        end
      rescue => e
        Rails.logger.error "event=report.case.exception bfkey=#{vacols_case.bfkey} message=#{e.message} traceback=#{e.backtrace}"
      end
      # Clear the list of eFolder documents on the case, otherwise the memory of
      # this script grows over time.
      vacols_case.clear_efolder_cache!
    end
  end
end

if __FILE__ == $0
  main(ARGV)
end
