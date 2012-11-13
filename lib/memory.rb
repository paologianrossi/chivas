class Memory

  attr_accessor :size
  
  def initialize(options = {})
    @size = options[:size] or raise "Size is a required parameter to Memory"
    @storage = []
  end

  def store(address)
    check_address(address)
    value = Integer(yield(address))
    @storage[address]=value
  end

  def read(address)
    check_address(address)
    @storage[address]
  end

  def reset
    @storage = []
  end
  
  private
  def check_address(address)
    raise "Address #{address} is out of bounds. Expected between 0 and #{size - 1}" unless address < size && address >=0
  end
end
