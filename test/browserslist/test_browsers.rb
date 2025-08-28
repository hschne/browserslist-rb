# frozen_string_literal: true

require_relative "../test_helper"

module Browserslist
  class TestBrowsers < Minitest::Test
    def setup
      @original_strict = Browserslist.configuration.strict
      Browserslist.configuration.strict = false
    end

    def teardown
      Browserslist.configuration.strict = @original_strict
    end

    def test_parse_returns_minimal_versions
      content = {browsers: ["chrome 119", "chrome 118"]}.to_json

      browsers = Browserslist::Browsers.parse(content)

      assert_equal 118.0, browsers[:chrome]
    end

    def test_parse_handles_version_ranges
      content = {browsers: ["safari 18.5-18.6", "safari 17.2"]}.to_json

      browsers = Browserslist::Browsers.parse(content)

      assert_equal 17.2, browsers[:safari]
    end

    def test_parse_normalizes_browser_names
      content = {browsers: ["and_chr 118", "and_ff 120"]}.to_json

      browsers = Browserslist::Browsers.parse(content)

      assert_equal 118.0, browsers[:chrome]
      assert_equal 120.0, browsers[:firefox]
    end

    def test_parse_handles_unknown_browsers
      content = {browsers: ["unknown_browser 1.0", "chrome 119"]}.to_json

      browsers = Browserslist::Browsers.parse(content)

      assert_equal({chrome: 119.0}, browsers)
    end

    def test_parse_handles_malformed_entries
      content = {browsers: ["malformed_entry", "chrome 119"]}.to_json

      browsers = Browserslist::Browsers.parse(content)

      assert_equal({chrome: 119.0}, browsers)
    end

    def test_parse_strict_mode_adds_missing_browsers
      Browserslist.configuration.strict = true
      content = {browsers: ["chrome 119"]}.to_json

      browsers = Browserslist::Browsers.parse(content)

      assert_equal 119.0, browsers[:chrome]
      assert_equal false, browsers[:firefox]
      assert_equal false, browsers[:safari]
      assert_equal false, browsers[:edge]
      assert_equal false, browsers[:opera]
      assert_equal false, browsers[:ie]
    end

    def test_parse_non_strict_mode_omits_missing_browsers
      content = {browsers: ["chrome 119"]}.to_json
      browsers = Browserslist::Browsers.parse(content)

      assert_equal({chrome: 119.0}, browsers)
    end

    def test_file_contents_returns_nil_when_file_missing
      original_path = Browserslist.configuration.file_path
      Browserslist.configuration.file_path = "nonexistent.browserslist.json"

      browsers_parser = Browserslist::Browsers.new

      assert_output(/Warning.*not found/) do
        assert_nil browsers_parser.file_contents
      end
    ensure
      Browserslist.configuration.file_path = original_path
    end
  end
end
