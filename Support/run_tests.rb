#!/usr/bin/env ruby
require "#{ENV['TM_BUNDLE_SUPPORT']}/header.rb"

is_remote = ENV["REMOTE_HOST"] && ENV["REMOTE_PATH"] && ENV["LOCAL_PATH"]
file = ENV['TM_FILENAME']
dir = is_remote ? ENV['TM_DIRECTORY'].gsub(/#{ENV['LOCAL_PATH']}/,ENV["REMOTE_PATH"]) : ENV['TM_DIRECTORY']
cmd = is_remote ? "ssh #{ENV['REMOTE_HOST']}" : "/bin/sh"

show_page("Run #{file}", "PHPUnit - Run test") do
  output = `#{cmd} "cd \"#{dir}\"; phpunit #{file}"`
  puts output.escape_html.add_code_links
end
