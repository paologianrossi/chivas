require 'memory'
require 'cpu'

class VirtualMachine

  attr_accessor :ram, :cpu
  
  def initialize(args = {})
    @ram = args[:ram] || Memory.new(1000)
    @cpu = args[:cpu] || Cpu.new(ram: @ram)
  end

  def load(what)
    if what.respond_to?(:readlines)
      source = what.readlines
      binary = source.map do |l|
        l.chomp
        Integer(l) unless l.empty?
      end.select {|l| l}
    else
      binary = what.dup
    end
      @ram.storage = binary
  end

  def run
    @cpu.pc = 0
    @cpu.run
  end
  
end

