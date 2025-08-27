# frozen_string_literal: true

require "test_helper"

class TestBrowserslist < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil Browserslist::VERSION
  end
end
