# Dummy Case object used for testing.
# Makes testing different routes through the UI easier.
# Change values to see different things.
# See: ApplicationController::make_mock_case

class MockCase < Case

  def initialize(bfkey)
    @bfkey = bfkey
  end

  # -- Misc case data --

  def bfkey
    @bfkey
  end

  def bfcorlid
    '22222222C'
  end

  def bfcorkey
    '3479B8F9'
  end

  def bfac
    '3'
  end

  def bfmpro
    'ADV'
  end

  def efolder_appellant_id
    '22222222'
  end

  def appeal_type
    'Post Remand'
  end

  def folder
    MockFolder.new
  end

  # -- VACOLS Document Dates --

  # VACOLS Notice of Disagreement (NOD) Date
  def bfdnod
    Date.parse('2015-09-01')
  end

  # VACOLS Form 9 Date
  def bfd19
    Date.parse('2015-09-01')
  end

  # VACOLS Statement of Case (SOC) Date
  def bfdsoc
    Date.parse('2015-09-01')
  end

  # VACOLS Supplemental Statement of Case (SSOC) Date #1
  def bfssoc1
    nil
  end

  # VACOLS Supplemental Statement of Case (SSOC) Date #2
  def bfssoc2
    nil
  end

  # VACOLS Supplemental Statement of Case (SSOC) Date #3
  def bfssoc3
    nil
  end

  # VACOLS Supplemental Statement of Case (SSOC) Date #4
  def bfssoc4
    nil
  end

  # VACOLS Supplemental Statement of Case (SSOC) Date #5
  def bfssoc5
    nil
  end

  # -- VBMS Document Dates --

  def efolder_nod_date
    '09/01/2015'
  end

  def efolder_form9_date
    '09/01/2015'
  end

  def efolder_soc_date
    '09/01/2015'
  end

  def efolder_ssoc1_date
    nil
  end

  def efolder_ssoc2_date
    nil
  end

  def efolder_ssoc3_date
    nil
  end

  def efolder_ssoc4_date
    nil
  end

  def efolder_ssoc5_date
    nil
  end

  # -- Form 8 info --

  def correspondent
    MockCorrespondent.new
  end

  def appellant_name
    'Joe Snuffy'
  end

  def appellant_relationship
    'Self'
  end

  def full_name
    'Joe Snuffy'
  end

  def bfpdnum
    '123ABC'
  end

  def vso_full
    'Disabled American Veterans'
  end

  def hearing_requested?
    true
  end

  def ssoc_required?
    false
  end

  def regional_office_full
    'Philadelphia, PA'
  end

  def bfregoff
    'RO10'
  end

  def bfso
    nil
  end

  # -- Upload Form 8 --

  def efolder_case
    EFolder::MockEfolderCase.new
  end

  def save
    true
  end

  # When Caseflow has been used on a case
  def bfdcertool=(val)
    Date.parse('2015-09-01')
  end

  def bfdcertool
    Date.parse('2015-09-01')
  end

  # VACOLS certification date
  def bf41stat=(val)
    Date.parse('2015-09-01').to_s(:va_date)
  end

  def bf41stat
    Date.parse('2015-09-01')
  end

end