require 'player/human'

describe Human do
  let(:player) {Human.new(:x)}

  describe "#move" do
    it "should know how to make a move" do
      player.methods.should include :move
    end

    it "should ask for the next move" do
      player.stub(:puts)
      player.stub(:gets).and_return '1'
      move = player.move
      move.should == 1
    end

    it "should only accept an integer between 0 and 9" do
      player.stub(:puts)
      player.stub(:gets).and_return('','2.0','15','99','0')
      move = player.move
      move.should == 0
    end
  end
end