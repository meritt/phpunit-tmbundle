#!/usr/bin/env ruby
require "#{ENV['TM_BUNDLE_SUPPORT']}/header.rb"

is_remote = ENV["REMOTE_HOST"] && ENV["REMOTE_PATH"] && ENV["LOCAL_PATH"]
file = ENV['TM_FILENAME']
dir = is_remote ? ENV['TM_DIRECTORY'].gsub(/#{ENV['LOCAL_PATH']}/,ENV["REMOTE_PATH"]) : ENV['TM_DIRECTORY']
test_name = TestFinder.find_last_test_before_line(ENV['TM_FILEPATH'], ENV['TM_LINE_NUMBER'])
cmd = is_remote ? "ssh #{ENV['REMOTE_HOST']}" : "/bin/sh"

show_page("Run #{file}", "PHPUnit - Run test") do
  puts "<h1>#{test_name}</h1>"
  output = `#{cmd} "cd \"#{dir}\"; phpunit --filter #{test_name} #{file}"`
  puts output.escape_html.add_code_links
end
