#!/usr/bin/env ruby
require 'rubygems'
require 'xml'
require 'erb'
require "#{ENV['TM_BUNDLE_SUPPORT']}/header.rb"
require "#{ENV['TM_BUNDLE_SUPPORT']}/phpunit.rb"

test_name = TestFinder.find_last_test_before_line(ENV['TM_FILEPATH'], ENV['TM_LINE_NUMBER'])
file = ENV['TM_FILENAME']
dir = PHPUnit::Processor.is_remote? ? ENV['TM_DIRECTORY'].gsub(/#{ENV['LOCAL_PATH']}/,ENV["REMOTE_PATH"]) : ENV['TM_DIRECTORY']
cmd = "cd \"#{dir}\"; phpunit --log-junit /tmp/#{file}.xml --filter #{test_name} #{file} > /dev/null; cat /tmp/#{file}.xml; rm /tmp/#{file}.xml"
if PHPUnit::Processor.is_remote? 
  output = `ssh #{ENV['REMOTE_HOST']} "#{cmd}"`
else
  output = `#{cmd}`
end
results = PHPUnit::Processor.xml(output)
puts ERB.new(File.read("#{ENV['TM_BUNDLE_SUPPORT']}/results.html.erb")).result(binding)