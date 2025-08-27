# frozen_string_literal: true

module Browserslist
  class Configuration
    DEFAULT_FILE_PATH = ".browserslist.json"

    attr_accessor :file_path, :strict

    def initialize
      @file_path = DEFAULT_FILE_PATH
      @strict = true
    end

    def self.instance
      @instance ||= new
    end

    def self.configure
      yield(instance) if block_given?
    end
  end
end
