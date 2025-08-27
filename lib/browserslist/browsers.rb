# frozen_string_literal: true

require "json"

module Browserslist
  class Browsers
    def self.parse(content = nil)
      new.parse(content)
    end

    def parse(content = nil)
      content ||= file_contents
      return {} if content.nil?

      parse_content(content)
    end

    def file_contents
      file_path = Browserslist.configuration.file_path

      unless File.exist?(file_path)
        puts "Warning: Browserslist file '#{file_path}' not found. Run 'browserslist:update' to generate it."
        return nil
      end

      File.read(file_path)
    end

    private

    def parse_content(file_content)
      parsed_json = JSON.parse(file_content)
      browser_list = parsed_json["browsers"]

      result = {}
      browser_list.each do |browser_version|
        browser, version = browser_version.split(" ", 2)
        next unless browser && version

        normalized_browser = normalize_browser_name(browser)
        next if normalized_browser.nil?

        clean_version = extract_min_version(version)
        gem_version = Gem::Version.new(clean_version)

        if result[normalized_browser].nil? || gem_version < Gem::Version.new(result[normalized_browser].to_s)
          result[normalized_browser] = gem_version.version.to_f
        end
      end

      add_missing_browsers_if_strict(result)
    end

    def add_missing_browsers_if_strict(result)
      return result unless Browserslist.configuration.strict

      all_browsers = [:chrome, :firefox, :safari, :edge, :opera, :ie]

      all_browsers.each do |browser|
        result[browser] = false unless result.key?(browser)
      end

      result
    end

    def normalize_browser_name(browser)
      case browser
      when "chrome", "and_chr"
        :chrome
      when "firefox", "and_ff"
        :firefox
      when "safari", "ios_saf"
        :safari
      when "edge"
        :edge
      when "opera", "op_mob"
        :opera
      when "ie"
        :ie
      end
    end

    def extract_min_version(version_string)
      if version_string.include?("-")
        min_version, _max_version = version_string.split("-", 2)
        min_version
      else
        version_string
      end
    end
  end
end
