require 'test_helper'
require './app/controllers/web_controller'

class WebControllerTest < ActiveSupport::TestCase
  test 'no remarks stays as no remarks' do
    remarks_full = ''
    expected_remarks = ['', '']

    remarks = WebController.remarks_field_rollover(remarks_full)
    assert_equal(expected_remarks, remarks, 'Empty remarks should not have produced any remarks during rollover')
  end

  test 'short one line remark does not get split' do

  end

  test 'more than one line remark gets split' do

  end

  test 'long one line remark gets split' do

  end

  test 'remark with long first line gets split correctly' do

  end
end