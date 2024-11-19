# frozen-string-literal: true

require 'test_helper'

describe Slop::Options do
  before do
    @options = Slop::Options.new
  end

  describe "#on" do
    it "defaults to null type" do
      assert_kind_of Slop::NullOption, @options.on("--foo")
    end

    it "accepts custom types" do
      module Slop; class FooOption < Option; end; end
      assert_kind_of Slop::FooOption, @options.on("--foo", type: :foo)
    end

    it "adds multiple flags" do
      option = @options.on("-f", "-F", "--foo")
      assert_equal %w(-f -F --foo), option.flags
    end

    it "accepts a trailing description" do
      option = @options.on("--foo", "fooey")
      assert_equal "fooey", option.desc
    end

    it "adds the option" do
      option = @options.on("--foo")
      assert_equal [option], @options.to_a
    end

    it "raises an error when a duplicate flag is used" do
      @options.on("--foo")
      assert_raises(ArgumentError) { @options.on("--foo") }
    end
  end

  describe "#separator" do
    it "appends separators between options in order" do
      @options.separator("foo")
      @options.on("--foo")
      @options.separator("bar")

      assert_equal ["foo", "bar"], @options.separators
    end

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
    it "uses the method name as an option type" do
      option = @options.string("--name")
      assert_kind_of Slop::StringOption, option
    end
  end

  describe "#respond_to?" do
    it "handles custom types" do
      module Slop; class BarOption < Option; end; end
      assert @options.respond_to?(:bar)
    end
  end

  describe "#to_s" do
    it "is prefixed with the default banner" do
      assert_match(/^usage/, @options.to_s)
    end
  end

  describe "custom banner" do
    it "is prefixed with defined banner" do
      @options_config = Slop::Options.new(**{banner: "custom banner"})
      assert_match(/^custom banner/, @options_config.to_s)
    end
    it "banner is disabled" do
      @options_config = Slop::Options.new(**{banner: false})
      assert_match("", @options_config.to_s)
    end
  end
end
