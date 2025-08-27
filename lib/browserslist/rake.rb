# frozen_string_literal: true

require_relative "../browserslist"

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

