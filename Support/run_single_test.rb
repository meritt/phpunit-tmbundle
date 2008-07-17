#!/usr/bin/env ruby
require "#{ENV['TM_BUNDLE_SUPPORT']}/header.rb"

dir, file = ENV['TM_DIRECTORY'], ENV['TM_FILENAME']
test_name = TestFinder.find_last_test_before_line(ENV['TM_FILEPATH'], ENV['TM_LINE_NUMBER'])

show_page("Run #{file}", "PHPUnit - Run test") do
  puts "<h1>#{test_name}</h1>"
  output = `cd "#{dir}"; phpunit --filter #{test_name} #{file}`
  puts output.escape_html.add_code_links
end
