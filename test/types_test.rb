# frozen-string-literal: true

require 'test_helper'

describe Slop::IntegerOption do
  before do
    @options = Slop::Options.new
    @age     = @options.integer "--age"
    @minus   = @options.integer "--minus", validate_type: true
    @plus    = @options.integer "--plus"
    @result  = @options.parse %w(--age 20 --minus -10 --plus +30)
  end

  it "raises with invalid types" do
    assert_raises(Slop::InvalidOptionValue) do
      @result.parser.parse %w(--minus foo)
    end
  end
end
