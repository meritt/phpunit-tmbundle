require File.dirname(__FILE__) + '/spec_helper'

describe "String extensions" do
  it "should escape html" do
    "this\nis a test\n".escape_html.should == "this<br>\nis a test<br>\n"
    "this <thing/> & that".escape_html.should == "this &lt;thing/&gt; &amp; that"
  end
  
  it "should add code links" do
    "some text
/my/file:30
/your_file.php:20002
/Users/jeremy/src/gnip/api-libs/gnip-php/src/Services/Gnip.php on line 30".add_code_links.should == "some text
<a href='txmt://open?url=file:///my/file&line=30'>/my/file:30</a>
<a href='txmt://open?url=file:///your_file.php&line=20002'>/your_file.php:20002</a>
<a href='txmt://open?url=file:///Users/jeremy/src/gnip/api-libs/gnip-php/src/Services/Gnip.php&line=30'>/Users/jeremy/src/gnip/api-libs/gnip-php/src/Services/Gnip.php on line 30</a>"
  end
  
  it "should know if it starts_with something" do
    "foobar".starts_with?("foo").should be_true
    "foobar".starts_with?("f").should be_true
    "foobar".starts_with?("foob").should be_true
    "foobar".starts_with?("fdo").should be_false
    "foobar".starts_with?("o").should be_false
  end
end
