# frozen-string-literal: true

module Slop
  class Parser
    attr_reader :options

    attr_reader :config

    def initialize(options, **config)
      @options = options
      @config  = config
      reset
    end

    def reset
      @arguments = []
      @options.each(&:reset)
      self
    end

    private
  end
end
