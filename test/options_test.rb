# frozen-string-literal: true

require 'test_helper'

describe Slop::Options do
  before do
    @options = Slop::Options.new
  end

  describe "#separator" do
    it "appends strings to the last separator if no options exist" do
      @options.separator("foo")
      @options.separator("bar")

      assert_equal ["foo\nbar"], @options.separators
    end

    it "accepts a frozen argument, even when called multiple times for the same option" do
      @options.separator("foo".freeze)
      @options.separator("bar".freeze)
    end

    it "defaults to empty string" do
      @options.separator

      assert_equal [""], @options.separators
    end
  end

  describe "#method_missing" do
    it "raises if a type doesn't exist" do
      assert_raises(NoMethodError) { @options.unknown }
    end
  end

  describe "#respond_to?" do
    it "handles custom types" do
      module Slop; class BarOption < Option; end; end
      assert @options.respond_to?(:bar)
    end
  end

  describe "custom banner" do
    it "banner is disabled" do
      @options_config = Slop::Options.new(**{banner: false})
      assert_match("", @options_config.to_s)
    end
  end
end
