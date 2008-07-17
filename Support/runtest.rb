#!/usr/bin/env ruby
require "#{ENV['TM_BUNDLE_SUPPORT']}/header.rb"

dir, file = ENV['TM_DIRECTORY'], ENV['TM_FILENAME']

show_page("Run #{file}", "PHPUnit - Run test") do
  output = `cd "#{dir}"; phpunit #{file}`
  puts output.add_code_links.escape_line_breaks
end

