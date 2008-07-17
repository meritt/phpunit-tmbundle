#!/usr/bin/env ruby

require "#{ENV['TM_SUPPORT_PATH']}/lib/web_preview.rb"
require "#{ENV['TM_SUPPORT_PATH']}/lib/tm_parser.rb"

# if !ENV['TM_PU_TEST_PATH'] or !ENV['TM_PU_COVERAGE_PATH']
#   puts html_head(:window_title => "PHPUnit", :page_title => "PHPUnit", :sub_title => "Error")
#   puts <<-HTML
# <p><strong>Warning</strong>: for runing PHPUnit tests you need this parameters TM_PU_TEST_PATH and TM_PU_COVERAGE_PATH!</p>
# <p>You can make this in "Preferences"->"Advanced"->"Shell Variables". TM_PU_TEST_PATH - path to tests folder. TM_PU_COVERAGE_PATH - path to code-coverage folder.</p>
# HTML
#   abort
# end

class String
  def starts_with?(text)
    self[0..text.length-1] == text
  end
  
  def add_code_links
    gsub(/([\w\.-]*\/[\w\/\.-]+)\:(\d+)/) do |match|
      file = $1.starts_with?("/") ? $1 : File.join(ENV['TM_PROJECT_DIRECTORY'], $1)
      "<a href='txmt://open?url=file://#{file}&line=#{$2}'>#{match}</a>"
    end
  end

  def escape_line_breaks
    gsub(/\n/, "<br>\n")
  end
end

def show_page(title, sub)
  html_header(title, sub)
  
  yield
  
  html_footer()
rescue
  puts $!.message.gsub("\n", "<br>")
  puts "<br>"
  puts $!.backtrace.join("<br>")
end