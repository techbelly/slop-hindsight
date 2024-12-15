# frozen-string-literal: true

module Slop
  class Error < StandardError
  end

  class MissingArgument < Error
    attr_reader :flags
  end

  class UnknownOption < Error
    attr_reader :flag
  end

  class MissingRequiredOption < Error
  end
end
