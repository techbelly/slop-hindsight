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
  end
end
