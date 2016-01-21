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
    assert_equal cells[idx], "Y"

    c = Caseflow::Fakes::Case.new(folder: Caseflow::Fakes::Folder.new("VBMS"))
    cells = report.spreadsheet_cells(c)
    assert_equal cells[idx], "N"
  end

  test "potential_alternatives" do
    t1 = Date.parse('2016-01-01')
    t2 = Date.parse('2016-01-02')
    t3 = Date.parse('2016-03-01')

    c = Caseflow::Fakes::Case.new(
      bfdnod: t1,
      efolder_nod: t2,
      efolder_case: Caseflow::Fakes::EFolderCase.new([
        Caseflow::Fakes::Document.new(doc_type: EFolder::Case::NOD_DOC_TYPE_ID, received_at: t2)
      ]),
    )
    assert_equal Caseflow::Reports.potential_alternatives(c), ["NOD: 01/02/2016"]

    c = Caseflow::Fakes::Case.new(
      bfdnod: t2,
      efolder_nod: t1,
      efolder_case: Caseflow::Fakes::EFolderCase.new([
        Caseflow::Fakes::Document.new(doc_type: EFolder::Case::NOD_DOC_TYPE_ID, received_at: t1)
      ]),
    )
    assert_equal Caseflow::Reports.potential_alternatives(c), ["NOD: 01/01/2016"]

    c = Caseflow::Fakes::Case.new(
      bfdnod: t1,
      efolder_nod: t3,
      efolder_case: Caseflow::Fakes::EFolderCase.new([
        Caseflow::Fakes::Document.new(doc_type: EFolder::Case::NOD_DOC_TYPE_ID, received_at: t3)
      ])
    )
    assert_equal Caseflow::Reports.potential_alternatives(c), []
  end
end
