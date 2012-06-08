describe J do
  describe J::Tokenizer do
    it "should tokenize numbers with spaces ('2 2 2' => [2, 2, 2])" do
      J::Tokenizer.new("2 2 2").go.should == [2, 2, 2]
    end
    it "should tokenize numbers with decimals (\"2.1 _2 0.2\" => [2.1, -2, 0.2])" do
      J::Tokenizer.new("2.1 _2 0.2").go.should == [2.1, -2, 0.2]
    end
  end
  
  
  it "should parse '2+2'" do
    J.parse("2+2").should == 4
  end
end

