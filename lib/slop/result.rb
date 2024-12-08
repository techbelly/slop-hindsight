# frozen-string-literal: true

module Slop
  class Result
    attr_reader :parser, :options

    def initialize(parser)
      @parser  = parser
      @options = parser.options
    end

    private
  end
end
