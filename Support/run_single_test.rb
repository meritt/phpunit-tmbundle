#!/usr/bin/env ruby
require 'rubygems'
require 'xml'
require 'erb'
require "#{ENV['TM_BUNDLE_SUPPORT']}/header.rb"
require "#{ENV['TM_BUNDLE_SUPPORT']}/phpunit.rb"

test_name = TestFinder.find_last_test_before_line(ENV['TM_FILEPATH'], ENV['TM_LINE_NUMBER'])
is_remote = ENV["REMOTE_HOST"] && ENV["REMOTE_PATH"] && ENV["LOCAL_PATH"]
file = ENV['TM_FILENAME']
dir = is_remote ? ENV['TM_DIRECTORY'].gsub(/#{ENV['LOCAL_PATH']}/,ENV["REMOTE_PATH"]) : ENV['TM_DIRECTORY']
cmd = is_remote ? "ssh #{ENV['REMOTE_HOST']}" : "/bin/sh"
output = `#{cmd} "cd \"#{dir}\"; phpunit --log-xml /tmp/#{file}.xml --filter #{test_name} #{file} > /dev/null; cat /tmp/#{file}.xml; rm /tmp/#{file}.xml"`
results = PHPUnit::Processor.xml(output)
puts ERB.new(File.read("#{ENV['TM_BUNDLE_SUPPORT']}/results.html.erb")).result(binding)