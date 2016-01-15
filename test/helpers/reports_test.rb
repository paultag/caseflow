require "test_helper"


class ReportsTest < ActiveSupport::TestCase
  test "mismatched_dates" do
    t1 = Date.parse('2015-09-01')
    t2 = Date.parse('2015-09-02')

    f = Caseflow::Fakes::Case.new
    assert_equal Caseflow::Reports.mismatched_dates(f), ""

    f = Caseflow::Fakes::Case.new(bfdnod: t1)
    assert_equal Caseflow::Reports.mismatched_dates(f), "NOD"

    f = Caseflow::Fakes::Case.new(bfdnod: t1, efolder_nod: t1, bfd19: t2)
    assert_equal Caseflow::Reports.mismatched_dates(f), "Form 9"

    f = Caseflow::Fakes::Case.new(bfdnod: t1, bfd19: t2, efolder_soc: t2)
    assert_equal Caseflow::Reports.mismatched_dates(f), "NOD, Form 9, SOC"
  end

  test "SeamReport.spreadsheet_cells doesn't error" do
    c = Caseflow::Fakes::Case.new(folder: Caseflow::Fakes::Folder.new("Paper"))
    Caseflow::Reports::SeamReport.new.spreadsheet_cells(c)
  end

  test "MismatchedDocumentsReport.spreadsheet_cells doesn't error" do
    c = Caseflow::Fakes::Case.new(folder: Caseflow::Fakes::Folder.new("VBMS"))
    Caseflow::Reports::MismatchedDocumentsReport.new.spreadsheet_cells(c)
  end

  test "SeamReport.spreadsheet_cells includes merged" do
    report = Caseflow::Reports::SeamReport.new
    idx = report.spreadsheet_columns.find_index("IS MERGED")

    c = Caseflow::Fakes::Case.new(folder: Caseflow::Fakes::Folder.new("VBMS"), bfdc: "M")
    cells = report.spreadsheet_cells(c)
    assert_equal cells[idx], "Y"

    c = Caseflow::Fakes::Case.new(folder: Caseflow::Fakes::Folder.new("VBMS"))
    cells = report.spreadsheet_cells(c)
    assert_equal cells[idx], "N"
  end

  test "MismatchedDocumentsReport.spreadsheet_cells includes merged" do
    report = Caseflow::Reports::MismatchedDocumentsReport.new
    idx = report.spreadsheet_columns.find_index("IS MERGED")

    c = Caseflow::Fakes::Case.new(folder: Caseflow::Fakes::Folder.new("VBMS"), bfdc: "M")
    cells = report.spreadsheet_cells(c)
    assert_equal cells[idex], "Y"

    c = Caseflow::Fakes::Case.new(folder: Caseflow::Fakes::Folder.new("VBMS"))
    cells = report.spreadsheet_cells(c)
    assert_equal cells[idex], "N"
  end
end
