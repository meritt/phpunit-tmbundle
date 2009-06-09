class TestFinder
  def self.find_last_test_before_line(file, line_number)
    contents = File.read(file).split("\n")[0..(line_number.to_i - 1)].reverse.join
    next_test(contents) || next_test(File.read(file))
  end
  
  private
  
  def self.next_test(text)
    text =~ /function ((It|test)\w+)\(/ ? $1 : nil
  end
end
