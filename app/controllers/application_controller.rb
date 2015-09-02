class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # -- Reusable methods to use across inheriting controllers --
  def get_case(bfkey)
    if ENV['CASEFLOW_TEST']
      make_mock_case(bfkey)
    else
      Case.find(bfkey)
    end
  end

  # -- Build fake objects --
  def make_mock_case(bfkey)
    require 'mocha/test_unit'

    # Misc case data
    kase = Case.new
    kase.expects(:bfkey).returns(bfkey).at_least_once # Case ID
    kase.expects(:bfcorlid).returns('22222222C').at_least_once # Veteran ID (sort of, not SSN)
    kase.expects(:bfcorkey).returns('3479B8F9').at_least_once
    kase.expects(:bfac).returns('3').at_least_once # Type Action
    kase.expects(:bfmpro).returns('ADV').at_least_once # Appeal Status
    kase.expects(:efolder_appellant_id).returns('22222222').at_least_once
    kase.expects(:appeal_type).returns('Post Remand').at_least_once
    
    # What kind of case it is
    folder = Folder.new
    kase.folder = folder
    folder.expects(:file_type).returns('VBMS').at_least_once # Possible values 'VBMS', 'VVA', 'Paper'

    # VACOLS Document Dates
    kase.expects(:bfdnod).returns(Date.parse('2015-09-01')).at_least_once # VACOLS: Notice of Disagreement Date
    kase.expects(:bfd19).returns(Date.parse('2015-09-01')).at_least_once
    kase.expects(:bfdsoc).returns(Date.parse('2015-09-01')).at_least_once # VACOLS: Statement of Case Date
    kase.expects(:bfssoc1).returns(nil).at_least_once # VACOLS: Supplement SOC Dates (1-5)
    kase.expects(:bfssoc2).returns(nil).at_least_once
    kase.expects(:bfssoc3).returns(nil).at_least_once
    kase.expects(:bfssoc4).returns(nil).at_least_once
    kase.expects(:bfssoc5).returns(nil).at_least_once
    
    # VBMS Document Dates
    kase.expects(:efolder_nod_date).returns('09/01/2015').at_least_once # VBMS: Notice of Disagreement Date
    kase.expects(:efolder_form9_date).returns('09/01/2015').at_least_once # VBMS: Form 9 Date
    kase.expects(:efolder_soc_date).returns('09/01/2015').at_least_once # VBMS: Statement of Case Date
    kase.expects(:efolder_ssoc1_date).returns(nil).at_least_once # VBMS: Supplemental SOC Dates (1-5)
    kase.expects(:efolder_ssoc2_date).returns(nil).at_least_once
    kase.expects(:efolder_ssoc3_date).returns(nil).at_least_once
    kase.expects(:efolder_ssoc4_date).returns(nil).at_least_once
    kase.expects(:efolder_ssoc5_date).returns(nil).at_least_once

    # Form 8 info
    corres = Correspondent.new
    kase.expects(:correspondent).returns(corres).at_least_once
    corres.expects(:appellant_name).returns('Joe Snuffy').at_least_once
    corres.expects(:appellant_relationship).returns('Self').at_least_once
    corres.expects(:full_name).returns('Joe Snuffy').at_least_once
    kase.expects(:bfpdnum).returns('123ABC').at_least_once # Insurance number
    kase.expects(:vso_full).returns('Disabled American Veterans').at_least_once
    kase.expects(:hearing_requested).returns(true).at_least_once
    kase.expects(:ssoc_required).returns(false).at_least_once
    kase.expects(:regional_office_full).returns('Philadelphia, PA').at_least_once
    kase.expects(:bfregoff).returns('RO10').at_least_once # Regional office? Org element certifying appeal?
    kase.expects(:bfso).returns(nil).at_least_once # Service org. Possible values: L, T, U, W, nil

    # Upload form 8
    efolder_case = Object.new
    efolder_case.expects(:upload_form8).returns(true).at_least_once
    kase.expects(:efolder_case).returns(efolder_case).at_least_once
    kase.expects(:save).returns(true).at_least_once

    kase
  end

end





