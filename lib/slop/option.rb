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

    def finish(_result)
    end

    def flag
      flags.join(", ")
    end

    def key
      key = config[:key] || flags.last.sub(/\A--?/, '')
      key = key.tr '-', '_' if underscore_flags?
      key.to_sym
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
