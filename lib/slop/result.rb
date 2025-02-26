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

    def fetch(flag)
      o = option(flag)
      if o.nil?
        cleaned_key = clean_key(flag)
        raise UnknownOption.new("option not found: '#{cleaned_key}'", "#{cleaned_key}")
      else
        o.value
      end
    end

    def []=(flag, value)
      if o = option(flag)
        o.value = value
      else
        raise ArgumentError, "no option with flag `#{flag}'"
      end
    end
    alias set []=

    def option(flag)
      options.find do |o|
        o.flags.any? { |f| clean_key(f) == clean_key(flag) }
      end
    end

    def method_missing(name, *args, &block)
      if respond_to_missing?(name)
        (o = option(name.to_s.chomp("?"))) && used_options.include?(o)
      end
    end

    def respond_to_missing?(name, include_private = false)
      name.to_s.end_with?("?") || super
    end

    def used_options
      parser.used_options
    end

    def arguments
      parser.arguments
    end
    alias args arguments

    def to_hash
      Hash[options.reject(&:null?).map { |o| [o.key, o.value] }]
    end
    alias to_h to_hash

    private

    def clean_key(key)
      key = key.to_s.sub(/\A--?/, '')
      key = key.tr '-', '_' if parser.config[:underscore_flags]
      key.to_sym
    end
  end
end
