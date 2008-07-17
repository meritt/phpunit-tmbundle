#!/usr/bin/env ruby

require "#{ENV['TM_BUNDLE_SUPPORT']}/header.rb"

html_header("Run test", "PHPUnit - Run test")

dir, file = File.dirname(ENV['TM_FILEPATH']), File.basename(ENV['TM_FILEPATH'])

phpunit_output = `cd "#{dir}"; phpunit #{file}`
puts phpunit_output.gsub(/[\n]/, '<br>') 

html_footer()