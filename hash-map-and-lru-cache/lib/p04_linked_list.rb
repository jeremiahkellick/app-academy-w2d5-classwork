class Node
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    # optional but useful, connects previous link to next link
    # and removes self from list.
  end
end

class LinkedList
  include Enumerable

  def initialize
    @head, @tail = Node.new, Node.new
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    if @head.next == @tail
      return nil
    else
      return @head.next
    end
  end

  def last
    if @tail.prev == @head
      return nil
    else
      return @tail.prev
    end
  end

  def empty?
    @head.next == @tail
  end

  def get(key)
    self.each do |node|
      return node.val if node.key == key
    end
    nil
  end

  def include?(key)
    !!self.find { |n| n.key == key }
  end

  def append(key, val)
    node = Node.new(key, val)

    last = @tail.prev
    last.next = node
    node.next = @tail
    @tail.prev = node
    node.prev = last
  end

  def update(key, val)
    node = self.find { |n| n.key == key }
    unless node.nil?
      node.val = val
    end
  end

  def remove(key)
    node = self.find { |n| n.key == key }
    unless node.nil?
      (node.prev).next = node.next
      (node.next).prev = node.prev
    end
  end

  def each(&prc)
    current = @head.next
    until current == @tail
      prc.call(current)
      current = current.next
    end
    self
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
