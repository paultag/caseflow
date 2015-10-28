require 'test_helper'
require './app/controllers/web_controller'

class WebControllerTest < ActiveSupport::TestCase
  test 'empty remarks produces empty remarks' do
    remarks_test('', ['', ''])
  end

  test 'short one line remark does not get split' do
    remarks_input = 'blah blah blah'
    remarks_test(remarks_input, [remarks_input, ''])
  end

  test 'more than one line remark gets split' do
    remarks_test(
      "line 1\nline 2\nline 3",
      ['line 1 (continued)', "\nRemarks Continued:\nline 2\nline 3"]
    )
  end

  test 'long one line remark gets split' do
    remarks_input = '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
    remarks_test(remarks_input, ["#{remarks_input[0..694]} (continued)","\nRemarks Continued:\n#{remarks_input[695..(remarks_input.length)]}"])
  end

  test 'remark with long first line gets split correctly' do
    remarks_input = "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890\nline 1\nline 2"
    remarks_test(remarks_input, ["#{remarks_input[0..694]} (continued)","\nRemarks Continued:\n#{remarks_input[695..(remarks_input.length)]}"])
  end

  # --- Helper Methods ---
  def remarks_test(remarks_input, expected_remarks)
    remarks = WebController.remarks_field_rollover(remarks_input)
    assert_equal(expected_remarks[0], remarks[0], 'Remarks block #1 does not match expectations')
    assert_equal(expected_remarks[1], remarks[1], 'Remarks block #2 does not match expectations')
  end
end