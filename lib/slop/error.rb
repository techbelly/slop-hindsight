# frozen-string-literal: true

module Slop
  class Error < StandardError
  end

  class MissingArgument < Error
    attr_reader :flags
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
