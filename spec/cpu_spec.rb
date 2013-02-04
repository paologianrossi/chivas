require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'highline/simulate'

describe "Cpu" do
  let(:memory) { mock(Memory) }
  let(:cpu) { Cpu.new }

  describe "execute" do
    it "should add with code 0" do
      memory.should_receive(:read).and_return(30)
      cpu.ram = memory
      cpu.acc = 12
      cpu.exec(0, 100)
      cpu.acc.should be 42
    end

    it "should subtract with code 1" do
      memory.should_receive(:read).and_return(12)
      cpu.ram = memory
      cpu.acc = 42
      cpu.exec(1, 100)
      cpu.acc.should be 30
    end
    it "should read with code 2" do
      $terminal = cpu.io

      HighLine::Simulate.with('9999') do
        cpu.exec(2, 123)
      end
      cpu.acc.should eq(9999)
    end

    it "should write with code 3"

    it "should store with code 4" do
      memory.should_receive(:store).with(100)
      cpu.ram = memory
      cpu.exec(4, 100)
    end
    it "should load with code 5" do
      memory.should_receive(:read).with(100).and_return(123)
      cpu.ram = memory
      cpu.exec(5, 100)
      cpu.acc.should eq(123)
    end
    it "should jump with code 6" do
      cpu.exec(6, 123)
      cpu.pc.should eq(123)
    end
    it "should jzer with code 7" do
      cpu.acc = 0
      cpu.exec(7, 123)
      cpu.pc.should eq(123)
      cpu.acc = 55
      cpu.exec(7, 99)
      cpu.pc.should eq(123)
    end
    it "should stop with code 8" do
      cpu.instance_variable_set('@running', true)
      cpu.exec(8, 99)
      cpu.should_not be_running
    end
    it "should fail with any other code" do
      expect { cpu.exec(42, 192) }.to raise_error
    end
    it "should run a short program" do
      memory.should_receive(:read).with(0).and_return(5010)
      memory.should_receive(:read).with(1).and_return(11)
      memory.should_receive(:read).with(2).and_return(8000)
      memory.should_receive(:read).with(10).and_return(30)
      memory.should_receive(:read).with(11).and_return(12)

      cpu.ram = memory
      cpu.run
      cpu.acc.should eq(42)
    end
  end

  describe "inspection" do
    let(:cpu) { Cpu.new() }
    it "should show all registry data in the right format" do
      memory.should_receive(:read).with(0).and_return(8123)
      cpu.ram = memory
      cpu.acc=10
      cpu.run
      cpu.inspect.should eq("<CPU: [acc: 10] [PC: 1] [IR[8, 123]] STOPPED]>")
    end
  end

end
