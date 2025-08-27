# frozen_string_literal: true

require "tempfile"
require_relative "../test_helper"

module Browserslist
  class TestCli < Minitest::Test
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
  end
end
