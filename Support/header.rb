#!/usr/bin/env ruby

require "#{ENV['TM_SUPPORT_PATH']}/lib/web_preview"
require "#{ENV['TM_SUPPORT_PATH']}/lib/tm_parser"
require "#{File.dirname(__FILE__)}/string_ext"
require "#{File.dirname(__FILE__)}/test_finder"

def show_page(title, sub)
  html_header(title, sub)
  
  yield
  
  html_footer()
rescue
  puts $!.message.gsub("\n", "<br>")
  puts "<br>"
  puts $!.backtrace.join("<br>")
end