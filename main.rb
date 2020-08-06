module Enumerable
  def my_each
    return enum_for unless block_given?
    for e in self
      yield e
    end
  end

  def my_each_with_index
    return enum_for unless block_given?

    for i in 0..self.length - 1
      yield self[i], i
    end
  end

  def my_select
    return enum_for unless block_given?
    new_arr = []
    count = 0
    my_each do |_element|
      new_arr << self[count] if yield(self[count])
      count += 1
    end
    new_arr
  end

  def my_all?
    if block_given?
      my_each do |element|
        return false unless yield element
      end
      true
    else
      return false if self.include?(nil || false)
    end
    true
  end

  def my_any?
    return false if empty?
    if block_given?
      self.my_each do |element|
        return true if yield element
      end
    end
    return !self.my_select { |x| x != false && x != nil }.empty?
  end

  def my_none?
    return true if empty?

    if block_given?
      for e in self
        if yield e
          return false
        else
          return true
        end
      end
    else
      if !(self.my_any? || self.my_all?)
        return true
      else
        return false
      end
    end
  end

  def my_count(arg = nil)
    count = 0
    return self.length unless arg || block_given?
    return self.my_select { |e| e == arg }.length if arg
    if block_given?
      for e in self
        count += 1 if yield e
      end
      return count
    end
  end

  def my_map(proc = nil)
    new_arr = []
    return enum_for unless proc || block_given?
    for e in self
      new_arr << proc ? proc.call(e) : yield(e)
    end
    return new_arr
  end

  def my_inject(initial = nil, sym = nil)
    if block_given?
      acc = initial || self[0]
      start = initial ? 0 : 1
      for i in start..self.length - 1
        acc = yield(acc, self[i])
      end
    else
      acc = initial.is_a?(Symbol) ? self[0] : initial
      start = initial.is_a?(Symbol) ? 1 : 0
      symbol = sym || initial

      for i in start..self.length - 1
        acc = acc.send(symbol, self[i])
      end
    end
    acc
  end
end
