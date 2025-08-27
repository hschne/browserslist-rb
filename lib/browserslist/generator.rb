# frozen_string_literal: true

require "open3"

module Browserslist
  class Generator
    def self.generate(options = {})
      new.generate(options)
    end

    def generate(options = {})
      query = options[:query]
      file_path = options[:file_path] || Browserslist.configuration.file_path

      output = fetch_browserslist_data(query)
      File.write(file_path, output)
      file_path
    end

    private

    def fetch_browserslist_data(query = nil)
      check_npx_availability!

      cmd = ["npx", "browserslist"]
      cmd << query if query

      stdout, stderr, status = Open3.capture3(*cmd)

      if status.success?
        stdout.strip
      else
        raise Error, "Failed to run browserslist: #{stderr}"
      end
    end

    def check_npx_availability!
      return if system("which npx > /dev/null 2>&1")

      raise Error, "npx is not available. Please install Node.js and npm."
    end
  end
end
