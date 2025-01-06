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

describe Slop::FloatOption do
  before do
    @options = Slop::Options.new
    @apr     = @options.float "--apr"
    @apr_value = 2.9
    @minus = @options.float "--minus", validate_type: true
    @plus = @options.float "--plus"
    @scientific_notation = @options.float "--scientific-notation"
    @scientific_notation_value = 4e21
    @result  = @options.parse %W(--apr #{@apr_value} --minus -6.1 --plus +9.4 --scientific-notation #{@scientific_notation_value})
  end

  it "raises with invalid types" do
    assert_raises(Slop::InvalidOptionValue) do
      @result.parser.parse %w(--minus foo)
    end
  end
end
