#!/usr/bin/env ruby

require "#{ENV['TM_SUPPORT_PATH']}/lib/web_preview.rb"

if !ENV['TM_PU_TEST_PATH'] or !ENV['TM_PU_COVERAGE_PATH']
  puts html_head(:window_title => "PHPUnit", :page_title => "PHPUnit", :sub_title => "Error")
  puts <<-HTML
<p><strong>Warning</strong>: for runing PHPUnit tests you need this parameters TM_PU_TEST_PATH and TM_PU_COVERAGE_PATH!</p>
<p>You can make this in "Preferences"->"Advanced"->"Shell Variables". TM_PU_TEST_PATH - path to tests folder. TM_PU_COVERAGE_PATH - path to code-coverage folder.</p>
HTML
  abort
end

`open "#{ENV['TM_PU_COVERAGE_PATH']}"/index.html`