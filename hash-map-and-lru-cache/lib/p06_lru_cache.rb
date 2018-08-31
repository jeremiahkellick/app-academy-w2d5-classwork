require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :count
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    node = @map[key]
    if node
      update_node!(node)
      node.val
    else
      node = @store.append(key, calc!(key))
      @map[key] = node
      eject! if @map.count > @max
      node.val
    end
  end

  def to_s
    'Map: ' + @map.to_s + '\n' + 'Store: ' + @store.to_s
  end

  private

  def calc!(key)
    @prc.call(key)
  end

  def update_node!(node)
    @store.move_to_end(node)
  end

  def eject!
    @map.delete(@store.shift.key)
  end
end
