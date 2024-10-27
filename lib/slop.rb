# frozen-string-literal: true

require 'slop/option'
require 'slop/options'
require 'slop/parser'

module Slop
  def self.option_defined?(name)
    const_defined?(string_to_option(name.to_s))
  rescue NameError
    false
  end

  def self.string_to_option(s)
    s.gsub(/(?:^|_)([a-z])/) { $1.capitalize } + "Option"
  end
end
