# frozen_string_literal: true

require_relative "browserslist/version"
require_relative "browserslist/configuration"
require_relative "browserslist/cli"
require_relative "browserslist/browsers"
require_relative "browserslist/generator"

module Browserslist
  class Error < StandardError; end

  def self.configuration
    Configuration.instance
  end

  def self.configure(&block)
    Configuration.configure(&block)
  end

  def self.browsers
    @browsers ||= Browsers.parse
  end

  def self.generate(options = {})
    Generator.generate(options)
  end
end
