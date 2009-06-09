#!/usr/bin/env ruby
require 'rubygems'
require 'xml'
require 'erb'
require "#{ENV['TM_BUNDLE_SUPPORT']}/header.rb"
require "#{ENV['TM_BUNDLE_SUPPORT']}/phpunit.rb"

file = ENV['TM_FILENAME']
dir = PHPUnit::Processor.is_remote? ? ENV['TM_DIRECTORY'].gsub(/#{ENV['LOCAL_PATH']}/,ENV["REMOTE_PATH"]) : ENV['TM_DIRECTORY']
if PHPUnit::Processor.is_remote? 
  output = `ssh #{ENV['REMOTE_HOST']} "cd #{dir}; phpunit --log-xml /tmp/#{file}.xml #{file} > /dev/null; cat /tmp/#{file}.xml; rm /tmp/#{file}.xml"`
else
  output = `cd #{dir}; phpunit --log-xml /tmp/#{file}.xml #{file} > /dev/null; cat /tmp/#{file}.xml; rm /tmp/#{file}.xml`
end

results = PHPUnit::Processor.xml(output)
puts ERB.new(File.read("#{ENV['TM_BUNDLE_SUPPORT']}/results.html.erb")).result(binding)