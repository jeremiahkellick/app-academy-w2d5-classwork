require_relative 'p04_linked_list'

class HashMap
  include Enumerable

  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket(key).include?(key)
  end

  def set(key, val)
    if self.include?(key)
      bucket(key).update(key, val)
    else
      resize! if @count == @store.length
      bucket(key).append(key, val)
      @count += 1
    end
  end

  def get(key)
    node = bucket(key).find { |node| node.key == key }
    if node.nil?
      return nil
    else
      return node.val
    end
  end

  def delete(key)
    @count -= 1 if self.include?(key)
    bucket(key).remove(key)
  end

  def each(&prc)
    @store.each do |bucket|
      bucket.each do |node|
        prc.call(node.key, node.val)
      end
    end
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    new_store = Array.new(@store.length * 2) { LinkedList.new }
    @store.each do |bucket|
      bucket.each do |node|
        new_store[node.key.hash % new_store.length].append(node.key, node.val)
      end
    end

    @store = new_store
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`

    @store[key.hash % @store.length]
  end
end
