# frozen-string-literal: true

module Slop
  class StringOption < Option
  end

  class BoolOption < Option
  end
  BooleanOption = BoolOption

  class IntegerOption < Option
    INT_STRING_REGEXP = /\A[+-]?\d+\z/.freeze

    def valid?(value)
      value =~ INT_STRING_REGEXP
    end
  end

  class NullOption < BoolOption
  end
end
