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

  test "safe_join" do
    base = Pathname.new("/a/b/c")

    assert_equal Caseflow.safe_join(base, "abc.txt"), Pathname.new("/a/b/c/abc.txt")
    assert Caseflow.safe_join(base, "..").nil?
    assert Caseflow.safe_join(base, "../cd").nil?
  end
end
