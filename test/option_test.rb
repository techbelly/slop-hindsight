# frozen-string-literal: true

require 'test_helper'

describe Slop::Option do
  def option(*args, **kwargs, &block)
    Slop::Option.new(*args, **kwargs, &block)
  end

  describe "#flag" do
    it "returns the flags joined by a comma" do
      assert_equal "-f, --bar", option(%w(-f --bar), nil).flag
      assert_equal "--bar", option(%w(--bar), nil).flag
    end
  end
end
