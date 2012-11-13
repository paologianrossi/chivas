class Memory

  # the number of words the instance of Memory can hold
  attr_accessor :size

  # create a new instance of Memory with given +size+
  def initialize(size)
    @size = size or raise "Size is a required parameter to Memory"
    @storage = []
  end

  # store a value in the Memory instance at address +address+. The
  # value is what is returned by the yielded block, and should be an
  # integer value, while +address+ should be between 0 and +size+
  def store(address)
    check_address(address)
    value = Integer(yield(address))
    @storage[address]=value
  end

  # returns the value stored in the Memory instance at address
  # +address+, or +nil+ if no value was stored at said address.
  def read(address)
    check_address(address)
    @storage[address]
  end

  # resets all cells to +nil+, as if the instance was power cycled.
  def reset
    @storage = []
  end
  
  private
  def check_address(address)
    raise "Address #{address} is out of bounds. Expected between 0 and #{size - 1}" unless address < size && address >=0
  end
end
