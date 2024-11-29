# frozen-string-literal: true

module Slop
  class StringOption < Option
  end

  class BoolOption < Option
  end
  BooleanOption = BoolOption

  class NullOption < BoolOption
  end
end
