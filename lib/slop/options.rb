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

    attr_reader :banner

    def initialize(**config, &block)
      @options    = []
      @separators = []
      @banner     = config[:banner].is_a?(String) ? config[:banner] : config.fetch(:banner, "usage: #{$0} [options]")
      @config     = DEFAULT_CONFIG.merge(config)
      @parser     = Parser.new(self, **@config)

      yield self if block_given?
    end

    def separator(string = "")
      if separators[options.size]
        separators[-1] += "\n#{string}"
      else
        separators[options.size] = string
      end
    end

    def each(&block)
      options.each(&block)
    end

    def respond_to_missing?(name, include_private = false)
      Slop.option_defined?(name) || super
    end

    def to_s(prefix: " " * 4)
      str = config[:banner] ? "#{banner}\n" : ""
      len = longest_flag_length

      options.select.each_with_index.sort_by{ |o,i| [o.tail, i] }.each do |opt, i|
        if sep = separators[i]
          str += "#{sep}\n"
        end

        str += "#{prefix}#{opt.to_s(offset: len)}\n" if opt.help?
      end

      if sep = separators[options.size]
        str += "#{sep}\n"
      end

      str
    end

    private

    def longest_flag_length
      (o = longest_option) && o.flag.length || 0
    end

    def longest_option
      options.max { |a, b| a.flag.length <=> b.flag.length }
    end
  end
end
