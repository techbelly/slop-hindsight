# frozen-string-literal: true

module Slop
  class StringOption < Option
    def call(value)
      value.to_s
    end
  end

  class SymbolOption < Option
    def call(value)
      value.to_sym
    end
  end

  class BoolOption < Option
    attr_accessor :explicit_value

    FALSE_VALUES = [false, 'false', 'no', 'off', '0'].freeze

    def valid?(value)
      return true unless config[:validate_type]
    end

    def call(value)
      self.explicit_value = value
      !force_false?
    end

    def value
      super
    end

    def force_false?
      FALSE_VALUES.include?(explicit_value)
    end

    def expects_argument?
      false
    end
  end
  BooleanOption = BoolOption

  class IntegerOption < Option
    INT_STRING_REGEXP = /\A[+-]?\d+\z/.freeze

    def valid?(value)
      value =~ INT_STRING_REGEXP
    end

    def call(value)
      value.to_i
    end
  end

  class FloatOption < Option
    FLOAT_STRING_REGEXP = /\A[+-]?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+-]?\d+)?\z/.freeze

    def valid?(value)
      value =~ FLOAT_STRING_REGEXP
    end

    def call(value)
      value.to_f
    end
  end

  class ArrayOption < Option
    def call(value)
      @value ||= []
      if delimiter
        @value.concat value.split(delimiter, limit)
      else
        @value << value
      end
    end

    def default_value
      config[:default] || []
    end

    def delimiter
      config.fetch(:delimiter, ",")
    end

    def limit
      config[:limit] || 0
    end
  end

  class RegexpOption < Option
    def call(value)
      Regexp.new(value)
    end
  end

  class NullOption < BoolOption
  end
end
