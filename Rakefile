# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

require "standard/rake"

task default: %i[test standard]

require_relative "lib/browserslist"
require "optparse"

namespace :browserslist do
  desc "Generate .browserslist.json file"
  task :update do
    file_path = Browserslist.generate
    puts "Generated browserslist file: #{file_path}"
  rescue Browserslist::Error => e
    puts "Error: #{e.message}"
    exit 1
  end
end
