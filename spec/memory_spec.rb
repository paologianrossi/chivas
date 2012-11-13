require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Memory" do
  let(:ram) { Memory.new(1024) }
  it "should store values in cells" do
    ram.store(20) { 23 }
    ram.read(20).should be 23
  end
  
  it "should fail if addressed over size" do
    expect {ram.store(1024) {2}}.to raise_error(/out of bounds/)
    expect {ram.read(1025)}.to raise_error(/out of bounds/)
  end
  it "should fail if addressed negatively" do
    expect {ram.store(-1) {2}}.to raise_error(/out of bounds/)
    expect {ram.read(-3)}.to raise_error(/out of bounds/)
  end
  it "should overwrite values in cells" do
    ram.store(20) { 24 }
    ram.store(20) { 50 }
    ram.read(20).should be 50
  end
  it "should fail if requested to store a non-integer value" do
    expect {ram.store(10) {"pippo"}}.to raise_error(ArgumentError)
    expect {ram.store(10) {"124"}}.not_to raise_error(ArgumentError)
  end

  it "should be resettable" do
    ram.store(10) { 40 }
    ram.read(10).should be 40
    ram.reset
    ram.read(10).should be_nil
  end

end
