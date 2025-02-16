# frozen-string-literal: true

module Slop
  class Option
    DEFAULT_CONFIG = {
      help: true,
      tail: false,
      underscore_flags: true,
      required: false,
    }

    attr_reader :flags

    attr_reader :desc

    attr_reader :config

    attr_reader :count

    attr_reader :block

    attr_writer :value

    def initialize(flags, desc, **config, &block)
      @flags  = flags
      @desc   = desc
      @config = DEFAULT_CONFIG.merge(config)
      @block  = block
      reset
    end

    def reset
      @value = nil
      @count = 0
    end

    def ensure_call(value)
      @count += 1

      if value.nil? && expects_argument?
        if default_value
          @value = default_value
        elsif !suppress_errors?
          raise Slop::MissingArgument.new("missing argument for #{flag}", flags)
        end
      else
        if validate_type? && !valid?(value) && !suppress_errors?
          raise Slop::InvalidOptionValue.new("invalid value for #{flag}", flags)
        end

        @value = valid?(value) && call(value)
      end

      block.call(@value) if block.respond_to?(:call)
    end

    def call(_value)
      raise NotImplementedError,
        "you must override the `call' method for option #{self.class}"
    end

    def finish(_result)
    end

    def expects_argument?
      true
    end

    def value
      @value || default_value
    end

    def default_value
      config[:default]
    end

    def suppress_errors?
      config[:suppress_errors]
    end

    def validate_type?
      config[:validate_type] || config[:validate_types]
    end

    def flag
      flags.join(", ")
    end

    def key
      key = config[:key] || flags.last.sub(/\A--?/, '')
      key = key.tr '-', '_' if underscore_flags?
      key.to_sym
    end

    def valid?(value)
      true
    end

    def underscore_flags?
      config[:underscore_flags]
    end

    def help?
      config[:help]
    end

    def tail?
      config[:tail]
    end

    def tail
      tail? ? 1 : -1
    end

    def to_s(offset: 0)
      "%-#{offset}s  %s" % [flag, desc]
    end
  end
end
