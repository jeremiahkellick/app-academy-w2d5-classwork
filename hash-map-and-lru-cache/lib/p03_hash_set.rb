class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    unless self.include?(key)
      # if num_el > num_buckets, resize
      resize! if @count == @store.length
      self[key] << key

      @count += 1
    end
  end

  def include?(key)
    self[key].include?(key)
  end

  def remove(key)
    idx = self[key].find_index(key)
    unless idx.nil?
      self[key].delete_at(idx)
      @count -= 1
    end
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num.hash % @store.length]
  end

  def num_buckets
    @store.length
  end

  def resize!
    new_store = Array.new(@store.length * 2) { Array.new }
    @store.each do |bucket|
      bucket.each do |el|
        new_store[el.hash % new_store.length] << el
      end
    end

    @store = new_store
  end
end
