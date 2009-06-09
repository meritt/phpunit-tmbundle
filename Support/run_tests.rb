#!/usr/bin/env ruby
require 'rubygems'
require 'xml'
require 'erb'
require "#{ENV['TM_BUNDLE_SUPPORT']}/header.rb"

is_remote = ENV["REMOTE_HOST"] && ENV["REMOTE_PATH"] && ENV["LOCAL_PATH"]
file = ENV['TM_FILENAME']
dir = is_remote ? ENV['TM_DIRECTORY'].gsub(/#{ENV['LOCAL_PATH']}/,ENV["REMOTE_PATH"]) : ENV['TM_DIRECTORY']
cmd = is_remote ? "ssh #{ENV['REMOTE_HOST']}" : "/bin/sh"

output = `#{cmd} "cd \"#{dir}\"; phpunit --log-xml /tmp/#{file}.xml #{file} > /dev/null; cat /tmp/#{file}.xml; rm /tmp/#{file}.xml"`


xml = XML::Document.string(output)
test_results = []

xml.find("/testsuites/testsuite/testcase").each do |tc|
  testcase = {}
  testcase['test'] = tc.attributes.get_attribute('name').value.to_s
  testcase['time'] = tc.attributes.get_attribute('time').value.to_f
  testcase['assertions'] = tc.attributes.get_attribute('assertions').value.to_i
  testcase['status'] = 'pass'
  if tc.children?
    testcase['status'] = 'fail' 
    testcase['message'] = tc.find_first('failure/text()').content.gsub(/^\n/, '').gsub(/^\s+\w/, '').gsub(/^.+#{ENV['REMOTE_PATH']}/, ENV['LOCAL_PATH']).escape_html.gsub(/<br>/, '').add_code_links
  end
  test_results << testcase
end

testsuite = xml.find_first("/testsuites/testsuite")
title = testsuite.attributes.get_attribute('name').value.gsub(/_/," ")

counts = {}
counts[:fail] = testsuite.attributes.get_attribute('failures').value.to_i
counts[:pass] = testsuite.attributes.get_attribute('tests').value.to_i - counts[:fail]
counts[:assertions] = testsuite.attributes.get_attribute('tests').value.to_i
overall_status = counts[:fail] > 0 ? 'fail' : 'pass'
total_time = testsuite.attributes.get_attribute('time').value.to_f

puts ERB.new(File.read("#{ENV['TM_BUNDLE_SUPPORT']}/results.html.erb")).result(binding)
