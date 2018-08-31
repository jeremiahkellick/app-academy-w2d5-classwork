class StaticArray
  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    @store[i]
  end

  def []=(i, val)
    validate!(i)
    @store[i] = val
  end

  def length
    @store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, @store.length - 1)
  end
end

class DynamicArray
  include Enumerable

  attr_reader :count

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    i = @count + i if i < 0
    @store[i]
  rescue => e
    if e.message == "Overflow error"
      return nil
    else
      raise
    end
  end

  def []=(i, val)
    i = @count + i if i < 0
    resize! while i >= @store.length
    @store[i] = val
  end

  def capacity
    @store.length
  end

  def push(val)
    resize! if @count == @store.length
    @store[@count] = val
    @count += 1
  end

  def unshift(val)
    resize! if @count == @store.length
    (@store.length - 1).downto(1).each do |i|
      @store[i] = @store[i - 1]
    end
    @store[0] = val
  end

  def pop
    return nil if @count == 0
    popped = @store[@count - 1]
    @store[@count - 1] = nil
    @count -= 1
    popped
  end

  def shift
    shifted = @store[0]
    (0..@store.length - 2).each do |i|
      @store[i] = @store[i + 1]
    end
    @count -= 1
    shifted
  end

  def first
    @store[0]
  end

  def last
    @store[@count - 1]
  end

  def each(&prc)
    (0...@count).each { |i| prc.call(@store[i]) }
    self
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    each_with_index { |el, i| return false unless other[i] == el }
    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    new_store = StaticArray.new(@store.length * 2)
    (0...@store.length).each { |i| new_store[i] = @store[i] }
    @store = new_store
  end
end
