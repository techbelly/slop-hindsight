# frozen-string-literal: true

module Slop
  class Result
    attr_reader :parser, :options

    def initialize(parser)
      @parser  = parser
      @options = parser.options
    end

    def [](flag)
      (o = option(flag)) && o.value
    end
    alias get []

    def option(flag)
      options.find do |o|
        o.flags.any? { |f| clean_key(f) == clean_key(flag) }
      end
    end

    def arguments
      parser.arguments
    end
    alias args arguments

    private

    def clean_key(key)
      key = key.to_s.sub(/\A--?/, '')
      key = key.tr '-', '_' if parser.config[:underscore_flags]
      key.to_sym
    end
  end
end
