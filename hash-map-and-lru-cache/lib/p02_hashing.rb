class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    combined = 0
    self.each_with_index { |el, i| combined = combined ^ (el + i) }
    combined.hash
  end
end

class String
  def hash
    combined = 0
    self.chars.each_with_index do |char, i|
      combined = combined ^ (char.ord + i)
    end
    combined.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    combined = 0
    self.each { |key, val| combined = combined ^ (key.to_s.hash + val.hash) }
    combined.hash
  end
end
