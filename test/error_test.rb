# frozen-string-literal: true

require 'test_helper'

describe Slop::MissingRequiredOption do
  it "raises when a required option is missing" do
    opts = Slop::Options.new
    opts.string "-n", "--name", required: true
    assert_raises(Slop::MissingRequiredOption) { opts.parse [] }
  end
end
