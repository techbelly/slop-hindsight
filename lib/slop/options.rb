# frozen-string-literal: true

module Slop
  class Options
    include Enumerable

    DEFAULT_CONFIG = {
      suppress_errors:  false,
      type:             "null",
      banner:           true,
      underscore_flags: true,
      validate_types:   false,
    }

    attr_reader :options

    attr_reader :separators

    attr_reader :config

    def initialize(**config, &block)
      @options    = []
      @separators = []
      @banner     = config[:banner].is_a?(String) ? config[:banner] : config.fetch(:banner, "usage: #{$0} [options]")
      @config     = DEFAULT_CONFIG.merge(config)
      @parser     = Parser.new(self, **@config)

      yield self if block_given?
    end

    def separator(string = "")
      separators[options.size] = string
    end

    def each(&block)
      options.each(&block)
    end

    def respond_to_missing?(name, include_private = false)
      Slop.option_defined?(name) || super
    end

    private
  end
end
