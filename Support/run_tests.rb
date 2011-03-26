#!/usr/bin/env ruby
require 'rubygems'
require 'xml'
require 'erb'
require "#{ENV['TM_BUNDLE_SUPPORT']}/header.rb"
require "#{ENV['TM_BUNDLE_SUPPORT']}/phpunit.rb"

file = ENV['TM_FILENAME']
infile = file

if infile =~ /\.xml$/
  infile = "--configuration #{infile}"
end

dir = PHPUnit::Processor.is_remote? ? ENV['TM_DIRECTORY'].gsub(/#{ENV['LOCAL_PATH']}/,ENV["REMOTE_PATH"]) : ENV['TM_DIRECTORY']
cmd = "cd \"#{dir}\"; phpunit --log-junit /tmp/#{file}.xml #{infile} > /tmp/#{file}.log; if [ -f /tmp/#{file}.xml ]; then cat /tmp/#{file}.xml; echo \"=log=\"; cat /tmp/#{file}.log; rm /tmp/#{file}.xml; rm /tmp/#{file}.log; fi;"
if PHPUnit::Processor.is_remote? 
  output = `ssh #{ENV['REMOTE_HOST']} "#{cmd}"`
else
  output = `#{cmd}`
end
xml, log = output.split('=log=')
results = PHPUnit::Processor.xml(xml)
puts ERB.new(File.read("#{ENV['TM_BUNDLE_SUPPORT']}/results.html.erb")).result(binding)