# frozen-string-literal: true

module Slop
  class Error < StandardError
  end

  class MissingArgument < Error
    attr_reader :flags

    def initialize(msg, flags)
      super(msg)
      @flags = flags
    end
  end

  class UnknownOption < Error
    attr_reader :flag

    def initialize(msg, flag)
      super(msg)
      @flag = flag
    end
  end

  class MissingRequiredOption < Error
  end
end
