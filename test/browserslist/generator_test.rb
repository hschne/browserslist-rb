# frozen_string_literal: true

require "tempfile"
require_relative "../test_helper"

module Browserslist
  class TestGenerator < Minitest::Test
    def setup
      @original_config = Browserslist.configuration.file_path
    end

    def teardown
      Browserslist.configuration.file_path = @original_config
    end

    def temp_file(suffix = ".browserslist")
      Tempfile.new(["browserslist_test", suffix]).path
    end

    def test_generate_creates_default_file
      skip_if_no_npx

      temp_path = temp_file
      file_path = Browserslist::Generator.generate(file_path: temp_path)

      assert_equal temp_path, file_path
      assert File.exist?(file_path)
      refute_empty File.read(file_path)
    end

    def test_generate_with_query
      skip_if_no_npx

      temp_path = temp_file
      file_path = Browserslist::Generator.generate(query: "last 1 versions", file_path: temp_path)

      assert_equal temp_path, file_path
      assert File.exist?(file_path)
      content = File.read(file_path)
      refute_empty content
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
