# Dummy Folder object used for testing.
# Makes testing different routes through the UI easier.
# Change values to see different things.
# See: ApplicationController::make_mock_case

class MockFolder
  def file_type
    # Possible values: 'Paper', 'VBMS', 'VVA'
    'VBMS'
  end
end