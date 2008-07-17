require File.dirname(__FILE__) + '/spec_helper'

describe TestFinder do
  FILE = File.dirname(__FILE__) + "/example_test.php"
  
  it "should find test before line 5" do
    TestFinder.find_last_test_before_line(FILE, 1).should == "testGetPublishers"
    TestFinder.find_last_test_before_line(FILE, 7).should == "testGetPublishers"
    TestFinder.find_last_test_before_line(FILE, 15).should == "testGetPublishers"
    TestFinder.find_last_test_before_line(FILE, 16).should == "testGetPublisher"
    TestFinder.find_last_test_before_line(FILE, 17).should == "testGetPublisher"
    TestFinder.find_last_test_before_line(FILE, 20).should == "testGetPublisher"
    TestFinder.find_last_test_before_line(FILE, 21).should == "testPublishActivities"
    TestFinder.find_last_test_before_line(FILE, 30).should == "testPublishActivities"
    TestFinder.find_last_test_before_line(FILE, 34).should == "testPublishActivities"
  end
end
