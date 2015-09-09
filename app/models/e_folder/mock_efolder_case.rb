# Dummy EFolder::Case object used for testing.
# Makes testing different routes through the UI easier.
# Change values to see different things.
# See: ApplicationController::make_mock_case

module EFolder
  class MockEfolderCase < EFolder::Case

    def initialize
    end

    def upload_form8(first_name, middle_init, last_name, file_name)
      true
    end
  end
end
