class Cpu
  attr_accessor :acc
  attr_accessor :ram
  attr_accessor :pc
  
  def initialize(options={})
    @ram = options[:ram]
    @pc = 0
  end

  def acc
    raise "Undefined accumulator value" if @acc.nil?
    @acc
  end
  
  def exec(opcode, arg)
    case opcode
    when 0
      self.acc = self.acc + ram.read(arg)
    when 1
      self.acc = self.acc - ram.read(arg)
    when 4
      ram.write(arg) { self.acc }
    when 5
      self.acc = ram.read(arg)
    when 6
      self.pc = arg
    when 7
      self.pc = arg if self.acc == 0
    when 8
      @running = false
    end    
  end

  def running?
    @running
  end
  
end
