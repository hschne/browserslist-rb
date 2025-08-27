# frozen_string_literal: true

require "optparse"

module Browserslist
  class Cli
    def initialize(argv)
      @argv = argv.dup
      @options = {}
    end

    def run
      parser.parse!(@argv)

      case @argv[0]
      when "generate", nil
        generate_command
      when "browsers"
        browsers_command
      else
        puts "Unknown command: #{@argv[0]}"
        puts parser.help
        exit 1
      end
    rescue Browserslist::Error => e
      puts "Error: #{e.message}"
      exit 1
    end

    private

    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = <<~BANNER
          Usage: browserslist [command] [options]

          Commands:
              generate [query]    Generate .browserslist file
              browsers            Show supported browsers (from existing file)

          Options:
        BANNER

        opts.on("-f", "--file PATH", "Output file path (default: .browserslist)") do |path|
          @options[:file_path] = path
        end

        opts.on("-h", "--help", "Show this help") do
          puts opts
          exit
        end
      end
    end

    def generate_command
      query = @argv[1]
      @options[:query] = query if query

      file_path = Browserslist.generate(@options)
      puts "Generated browserslist file: #{file_path}"
    end

    def browsers_command
      browsers = Browserslist.browsers

      if browsers.empty?
        puts "No browsers found. Run 'browserslist generate' first."
        exit 1
      end

      browsers.each do |browser, version|
        puts "#{browser}: #{version}"
      end
    end
  end
end
