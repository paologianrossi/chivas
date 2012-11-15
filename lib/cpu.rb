require 'highline'

class Cpu
  attr_accessor :acc
  attr_accessor :ram
  attr_accessor :pc
  attr_accessor :ir
  attr_accessor :io
  
  def initialize(options={})
    @ram = options[:ram]
    @io = options[:io] || HighLine.new
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
    when 2
      self.acc = self.io.ask("> ", Integer)
    when 3
      self.io.say("--> #{self.acc}")
    when 4
      ram.store(arg) { self.acc }
    when 5
      self.acc = ram.read(arg)
    when 6
      self.pc = arg
    when 7
      self.pc = arg if self.acc == 0
    when 8
      @running = false
    else
      raise "Unknown instruction code #{opcode}"
    end
  end

  def run
    @running = true
    begin
      while running?
        self.ir = decode(ram.read(self.pc))
        self.pc += 1
        exec(ir[0], ir[1])
      end
    end 
  end
  
  def running?
    @running
  end

  def inspect
    "<CPU: [acc: #{@acc}] [PC: #{@pc}] [IR#{@ir}] #{running? ? "RUNNING":"STOPPED"}]>"
  end
  
  private
  def decode(word)
    word.divmod(1000)
  end
end
