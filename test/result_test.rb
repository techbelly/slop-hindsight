# frozen-string-literal: true

require 'test_helper'

module Slop
  class ReverseEverythingOption < BoolOption
    def finish(result)
    end
  end
end

describe Slop::Result do
  before do
    @options     = Slop::Options.new
    @verbose     = @options.bool "-v", "--verbose"
    @name        = @options.string "--name"
    @unused      = @options.string "--unused"
    @long_option = @options.string "--long-option"
    @result      = @options.parse %w(foo -v --name lee --long-option bar argument)
  end

  it "increments option count" do
    assert_equal 1, @verbose.count
    assert_equal 1, @long_option.count
    @result.parser.parse %w(-v --verbose)
    assert_equal 2, @verbose.count
  end

  it "yields arguments to option blocks" do
    output = nil
    @options.string("--foo") { |v| output = v }
    @result.parser.parse %w(--foo bar)
    assert_equal output, "bar"
  end
end
