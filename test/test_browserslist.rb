# frozen_string_literal: true

require "test_helper"

class TestBrowserslist < Minitest::Test
  def setup
    @original_config = Browserslist.configuration.file_path
    @original_strict = Browserslist.configuration.strict
  end

  def teardown
    Browserslist.configuration.file_path = @original_config
    Browserslist.configuration.strict = @original_strict
  end

  def test_that_it_has_a_version_number
    refute_nil Browserslist::VERSION
  end

  def test_configuration_default_file_path
    assert_equal ".browserslist", Browserslist.configuration.file_path
  end

  def test_configuration_default_strict
    assert_equal true, Browserslist.configuration.strict
  end

  def test_configure_file_path
    Browserslist.configure do |config|
      config.file_path = "custom.browserslist"
    end

    assert_equal "custom.browserslist", Browserslist.configuration.file_path
  end

  def test_configure_strict
    Browserslist.configure do |config|
      config.strict = false
    end

    assert_equal false, Browserslist.configuration.strict
  end

  def test_browsers_returns_empty_when_no_file
    browsers = Browserslist.browsers

    assert_instance_of Hash, browsers
    assert_empty browsers
  end

  def test_browsers_delegates_to_browsers_class
    assert_respond_to Browserslist, :browsers
  end

  def test_generate_delegates_to_generator_class
    assert_respond_to Browserslist, :generate
  end
end
