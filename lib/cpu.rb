require 'highline'

class Cpu
  # Accumulator registry
  attr_accessor :acc

  # Memory
  attr_accessor :ram

  # Program Counter
  attr_accessor :pc

  # Instruction registry
  attr_accessor :ir

  # Input/Output device
  attr_accessor :io

  # Possible +options+ are +:ram+ and +:io+. The +io:+ option defaults
  # to an HighLine instance
  def initialize(options={})
    @ram = options[:ram]
    @io = options[:io] || HighLine.new
    @pc = 0
  end

  def acc
    raise "Undefined accumulator value" if @acc.nil?
    @acc
  end

  # Execute an instruction, or die trying.
  # Instructions are made of +opcode+ and +arg+. The +arg+ part, when
  # needed, is a memory address. When not needed is ignore. 
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

  # Run the cpu. While running, the cpu does a fetch-decode-execute
  # loop. The machine stops when it meets a '8xxx' instruction.
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

  # Is the machine running?
  def running?
    @running
  end

  # :nodoc:
  def inspect
    "<CPU: [acc: #{@acc}] [PC: #{@pc}] [IR#{@ir}] #{running? ? "RUNNING":"STOPPED"}]>"
  end
  
  private
  def decode(word)
    word.divmod(1000)
  end
end
