# frozen_string_literal: true

require_relative "../test_helper"

module Browserslist
  class TestGenerator < Minitest::Test
    def setup
      @original_config = Browserslist.configuration.file_path
    end

    def teardown
      Browserslist.configuration.file_path = @original_config
      File.delete(".browserslist") if File.exist?(".browserslist")
      File.delete("custom.browserslist") if File.exist?("custom.browserslist")
      File.delete("test_generator.browserslist") if File.exist?("test_generator.browserslist")
    end

    def test_generate_creates_default_file
      skip_if_no_npx

      file_path = Browserslist::Generator.generate

      assert_equal ".browserslist", file_path
      assert File.exist?(file_path)
      refute_empty File.read(file_path)
    end

    def test_generate_with_custom_file_path
      skip_if_no_npx

      file_path = Browserslist::Generator.generate(file_path: "custom.browserslist")

      assert_equal "custom.browserslist", file_path
      assert File.exist?(file_path)
      refute_empty File.read(file_path)
    end

    def test_generate_with_query
      skip_if_no_npx

      file_path = Browserslist::Generator.generate(query: "last 1 versions")

      assert_equal ".browserslist", file_path
      assert File.exist?(file_path)
      content = File.read(file_path)
      refute_empty content
    end

    def test_generate_with_query_and_custom_path
      skip_if_no_npx

      file_path = Browserslist::Generator.generate(
        query: "last 1 versions",
        file_path: "test_generator.browserslist"
      )

      assert_equal "test_generator.browserslist", file_path
      assert File.exist?(file_path)
      refute_empty File.read(file_path)
    end

    def test_generate_uses_configuration_file_path
      skip_if_no_npx

      Browserslist.configure do |config|
        config.file_path = "custom.browserslist"
      end

      file_path = Browserslist::Generator.generate

      assert_equal "custom.browserslist", file_path
      assert File.exist?(file_path)
    end

    def test_generate_file_path_option_overrides_config
      skip_if_no_npx

      Browserslist.configure do |config|
        config.file_path = "config.browserslist"
      end

      file_path = Browserslist::Generator.generate(file_path: "override.browserslist")

      assert_equal "override.browserslist", file_path
      assert File.exist?("override.browserslist")
      refute File.exist?("config.browserslist")
    ensure
      File.delete("override.browserslist") if File.exist?("override.browserslist")
    end

    def test_error_when_npx_unavailable
      original_path = ENV["PATH"]
      ENV["PATH"] = ""

      error = assert_raises(Browserslist::Error) do
        Browserslist::Generator.generate
      end

      assert_match(/npx is not available/, error.message)
    ensure
      ENV["PATH"] = original_path
    end

    private

    def skip_if_no_npx
      skip "npx not available" unless system("which npx > /dev/null 2>&1")
    end
  end
end
