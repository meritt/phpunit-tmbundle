module PHPUnit    
  class Processor
    def self.xml(output)
      results = {}
      xml = XML::Document.string(output)
      testsuites = xml.find("/testsuites/testsuite/testsuite") 
      if testsuites.length > 0
        master = xml.find_first("/testsuites/testsuite")
        results[:parent] = {
          :name => master.attributes.get_attribute('name').value,
        }

        results[:parent][:counts] = {}
        results[:parent][:counts][:fail] = master.attributes.get_attribute('failures').value.to_i
        results[:parent][:counts][:error] = master.attributes.get_attribute('errors').value.to_i
        results[:parent][:counts][:pass] = master.attributes.get_attribute('tests').value.to_i - results[:parent][:counts][:fail] - results[:parent][:counts][:error]
        results[:parent][:counts][:assertions] = master.attributes.get_attribute('tests').value.to_i
        results[:parent][:status] = (results[:parent][:counts][:fail] +  results[:parent][:counts][:error]) > 0 ? 'fail' : 'pass'
        results[:parent][:total_time] = master.attributes.get_attribute('time').value.to_f

      else
        testsuites = xml.find("/testsuites/testsuite")
      end

      results[:suites] = []
      testsuites.each do |ts|
        testsuite = {
          :name => ts.attributes.get_attribute('name').value.gsub(/_/," "),
          :cases => [],
          :counts => {}
        }

        testsuite[:counts] = {}
        testsuite[:counts][:fail] = ts.attributes.get_attribute('failures').value.to_i
        testsuite[:counts][:error] = ts.attributes.get_attribute('errors').value.to_i
        testsuite[:counts][:pass] = ts.attributes.get_attribute('tests').value.to_i - testsuite[:counts][:fail] - testsuite[:counts][:error]
        testsuite[:counts][:assertions] = ts.attributes.get_attribute('tests').value.to_i
        testsuite[:status] = (testsuite[:counts][:fail] + testsuite[:counts][:error]) > 0 ? 'fail' : 'pass'
        testsuite[:total_time] = ts.attributes.get_attribute('time').value.to_f

        ts.find("testcase").each do |tc|
          testcase = {}
          testcase[:test] = tc.attributes.get_attribute('name').value.to_s
          testcase[:time] = tc.attributes.get_attribute('time').value.to_f
          testcase[:assertions] = tc.attributes.get_attribute('assertions').value.to_i
          testcase[:status] = 'pass'
          if tc.children?            
            if tc.find_first('failure/text()')
              testcase[:status] = 'fail'
              testcase[:message] = tc.find_first('failure/text()').content.gsub(/^\n/, '').gsub(/^\s+\w/, '').escape_html.gsub(/<br>/, '').add_code_links
              testcase[:message] = tc.find_first('failure/text()').content.gsub(/^\n/, '').gsub(/^\s+\w/, '').gsub(/^.+#{ENV['REMOTE_PATH']}/, ENV['LOCAL_PATH']).escape_html.gsub(/<br>/, '').add_code_links if self.is_remote?
            end
            if tc.find_first('error/text()')
              testcase[:status] = 'error'
              testcase[:message] = tc.find_first('error/text()').content.gsub(/^\n/, '').gsub(/^\s+\w/, '').escape_html.gsub(/<br>/, '').add_code_links
              testcase[:message] = tc.find_first('error/text()').content.gsub(/^\n/, '').gsub(/^\s+\w/, '').gsub(/^.+#{ENV['REMOTE_PATH']}/, ENV['LOCAL_PATH']).escape_html.gsub(/<br>/, '').add_code_links if self.is_remote?
            end  
          end
          testsuite[:cases] << testcase
        end
        results[:suites] << testsuite
      end
      results
    end # process_xml_log
    
    def self.is_remote?
      ENV["REMOTE_HOST"] && ENV["REMOTE_PATH"] && ENV["LOCAL_PATH"]
    end
  end # Processor
end # PHPUnit