# frozen_string_literal: true

require_relative "../test_helper"

module Browserslist
  class TestCli < Minitest::Test
    def setup
      @original_config = Browserslist.configuration.file_path
    end

    def teardown
      Browserslist.configuration.file_path = @original_config
      File.delete(".browserslist") if File.exist?(".browserslist")
      File.delete("test_cli.browserslist") if File.exist?("test_cli.browserslist")
    end

    def test_generate_command
      skip_if_no_npx

      cli = Browserslist::Cli.new(["generate"])

      assert_output(/Generated browserslist file: \.browserslist/) do
        cli.run
      end

      assert File.exist?(".browserslist")
    end

    def test_generate_with_query
      skip_if_no_npx

      cli = Browserslist::Cli.new(["generate", "last 1 versions"])

      assert_output(/Generated browserslist file: \.browserslist/) do
        cli.run
      end

      assert File.exist?(".browserslist")
    end

    def test_generate_with_file_option
      skip_if_no_npx

      cli = Browserslist::Cli.new(["generate", "--file", "test_cli.browserslist"])

      assert_output(/Generated browserslist file: test_cli\.browserslist/) do
        cli.run
      end

      assert File.exist?("test_cli.browserslist")
    end

    def test_browsers_command_with_file
      create_test_browserslist_file

      cli = Browserslist::Cli.new(["browsers"])

      assert_output(/chrome: 118\.0\nfirefox: 120\.0/) do
        cli.run
      end
    end

    def test_browsers_command_without_file
      cli = Browserslist::Cli.new(["browsers"])

      assert_output(/No browsers found\. Run 'browserslist generate' first\./) do
        assert_raises(SystemExit) { cli.run }
      end
    end

    def test_help_command
      cli = Browserslist::Cli.new(["--help"])

      assert_output(/Usage: browserslist/) do
        assert_raises(SystemExit) { cli.run }
      end
    end

    def test_unknown_command
      cli = Browserslist::Cli.new(["unknown"])

      assert_output(/Unknown command: unknown/) do
        assert_raises(SystemExit) { cli.run }
      end
    end

    private

    def skip_if_no_npx
      skip "npx not available" unless system("which npx > /dev/null 2>&1")
    end

    def create_test_browserslist_file
      File.write(".browserslist", <<~CONTENT)
        chrome 119
        chrome 118
        firefox 121
        firefox 120
        safari 17.2
        safari 17.1
      CONTENT
    end
  end
end
