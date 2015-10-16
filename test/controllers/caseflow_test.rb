require "test_helper"

require "app/controllers/web_controller"


class CaseflowTest < ActiveSupport::TestCase
  test "is_child_path?" do
    base = Pathname.new("/a/b/c")

    assert Caseflow.is_child_path?(base, base + "foo.rb")
    assert Caseflow.is_child_path?(base, base + "directory" + "foo.rb")

    assert !Caseflow.is_child_path?(base, base + "..")
    assert !Caseflow.is_child_path?(base, base + "../cd")
  end
end
