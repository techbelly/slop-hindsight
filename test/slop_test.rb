# frozen-string-literal: true

require "test_helper"

describe Slop do
  describe ".option_defined?" do
    it "returns false if the option is not defined" do
      assert_equal false, Slop.option_defined?("FooBar")
    end
  end
end
