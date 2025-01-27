# frozen-string-literal: true

module Slop
  class Parser
    attr_reader :options

    attr_reader :config

    attr_reader :arguments

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
          if opt.expects_argument?

            if consume_next_argument?(orig_flag)
              pairs.delete_at(idx + 1)
            end

            arguments.each_with_index do |argument, i|
              if argument == orig_flag && !orig_flag.include?("=")
                arguments.delete_at(i + 1)
              end
            end
          end
          arguments.delete(orig_flag)
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

    def consume_next_argument?(flag)
      return false if flag.include?("=")
      return true if flag.start_with?("--")
      return true if /\A-[a-zA-Z]\z/ === flag
    end

    def process(option, arg)
      option.ensure_call(arg)
      option
    end

    def try_process(flag, arg)
      if option = matching_option(flag)
        process(option, arg)
      else
        if flag.start_with?("-") && !suppress_errors?
          raise UnknownOption.new("unknown option `#{flag}'", "#{flag}")
        end
      end
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
        [strings[0..partition_idx-1], strings[partition_idx+1..-1]]
      else
        [strings, []]
      end
    end
  end
end
