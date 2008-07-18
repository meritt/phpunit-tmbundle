class String
  def starts_with?(text)
    self[0..text.length-1] == text
  end
  
  def add_code_links
    gsub(/([\w\.-]*\/[\w\/\.-]+)\:(\d+)/) do |match|
      file = $1.starts_with?("/") ? $1 : File.join(Dir.pwd, $1)
      "<a href='txmt://open?url=file://#{file}&line=#{$2}'>#{match}</a>"
    end.gsub(/([\w\/\.-]+) on line (\d+)/) do |match|
      file = $1.starts_with?("/") ? $1 : File.join(Dir.pwd, $1)
      "<a href='txmt://open?url=file://#{file}&line=#{$2}'>#{match}</a>"
    end
  end

  def escape_html
    gsub('&', '&amp;').
    gsub('<', '&lt;').
    gsub('>', '&gt;').
    gsub(/\n/, "<br>\n")
  end
end
