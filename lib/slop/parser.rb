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

    def parse(strings)
      reset

      strings, ignored_args = partition(strings)

      pairs = strings.each_cons(2).to_a
      pairs << [strings.last, nil]

      @arguments = strings.dup

      pairs.each_with_index do |pair, idx|
        flag, arg = pair
        break if !flag

        orig_flag = flag.dup
        if match = flag.match(/([^=]+)=(.*)/)
          flag, arg = match.captures
        end

        if opt = try_process(flag, arg)
        end
      end

      @arguments += ignored_args

      if !suppress_errors?
        unused_options.each do |o|
          if o.config[:required]
            pretty_flags = o.flags.map { |f| "`#{f}'" }.join(", ")
            raise MissingRequiredOption, "missing required option #{pretty_flags}"
          end
        end
      end

      Result.new(self).tap do |result|
        used_options.each { |o| o.finish(result) }
      end
    end

    def used_options
      options.select { |o| o.count > 0 }
    end

    def unused_options
      options.to_a - used_options
    end

    private

    def try_process(flag, arg)
    end

    def suppress_errors?
      config[:suppress_errors]
    end

    def matching_option(flag)
      options.find { |o| o.flags.include?(flag) }
    end

    def partition(strings)
      if strings.include?("--")
        partition_idx = strings.index("--")
        return [[], strings[1..-1]] if partition_idx.zero?
      else
        [strings, []]
      end
    end
  end
end
