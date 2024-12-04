# frozen-string-literal: true

module Slop
  class Error < StandardError
  end

  class MissingRequiredOption < Error
  end
end
