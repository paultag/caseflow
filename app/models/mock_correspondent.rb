# Dummy Correspondent object used for testing.
# Makes testing different routes through the UI easier.
# Change values to see different things.
# See: ApplicationController::make_mock_case


class MockCorrespondent < Correspondent
  def appellant_name
    'Joe Snuffy'
  end

  def appellant_relationship
    'Self'
  end

  def full_name
    'Joe Snuffy'
  end
end