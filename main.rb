# rubocop:disable Style/CaseEquality
# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

module Enumerable
  def my_each
    arr = self.to_a
    return enum_for unless block_given?

    for e in arr
      yield e
    end
  end

  def my_each_with_index
    arr = self.to_a
    return enum_for unless block_given?

    arr.my_each do |e|
      yield(e, arr.index(e))
    end
  end

  def my_select
    return enum_for unless block_given?
    new_arr = []
    my_each do |element|
      new_arr << element if yield(element)
    end
    new_arr
  end

  def my_all?(arg = nil)
    arr = self.to_a
    if !arg.nil?
      case arg
      when Regexp
        return arr.my_select { |x| x =~ arg }.length == arr.length
      when Class
        return arr.my_select { |x| x.is_a?(arg) }.length == arr.length
      else
        return arr.my_select { |x| x == arg }.length == arr.length
      end
    end

    if arg.nil? && block_given?
      my_each do |element|
        return false unless yield element
      end
    end
    return !(arr.include?(nil) || arr.include?(false))
  end

  def my_any?(arg = nil)
    arr = self.to_a
    return false if arr.to_a.empty?
    if !arg.nil?
      case arg
      when Regexp
        return !arr.my_select { |x| x =~ arg }.empty?
      when Class
        return !arr.my_select { |x| x.is_a?(arg) }.empty?
      else
        return !arr.my_select { |x| x == arg }.empty?
      end
    end

    if arg.nil? && block_given?
      my_each do |element|
        return false unless yield(element)
      end
    end
    return !arr.my_select { |x| x != false && x != nil }.empty?
  end

  def my_none?(arg = nil)
    arr = self.to_a
    return true if self.to_a.empty?

    if !arg.nil?
      case arg
      when Regexp
        return arr.my_select { |x| x =~ arg }.empty?
      when Class
        return arr.my_select { |x| x.is_a?(arg) }.empty?
      else
        return arr.my_select { |x| x == arg }.empty?
      end
    end

    if block_given? && arg.nil?
      result = true
      for e in arr
        if yield(e)
          result = false
        end
      end
      return result
    end

    return !(arr.any?)
  end

  def my_count(arg = nil)
    arr = self.to_a
    count = 0
    return arr.length unless arg || block_given?
    return arr.my_select { |e| e == arg }.length if arg
    if block_given?
      for e in arr
        count += 1 if yield e
      end
      return count
    end
  end

  def my_map(proc = nil)
    arr - self.to_a
    new_arr = []
    return enum_for unless proc || block_given?
    for e in arr
      new_arr << (proc ? proc.call(e) : yield(e))
    end
    return new_arr
  end

  def my_inject(initial = nil, sym = nil)
    arr = self.to_a
    if block_given?
      acc = initial || arr[0]
      start = initial ? 0 : 1
      for i in start..arr.length - 1
        acc = yield(acc, arr[i])
      end
    else
      acc = initial.is_a?(Symbol) ? arr[0] : initial
      start = initial.is_a?(Symbol) ? 1 : 0
      symbol = sym || initial

      for i in start..arr.length - 1
        acc = acc.send(symbol, arr[i])
      end
    end
    acc
  end
end

def multiply_els(arr)
  arr.my_inject { |acc, element| acc * element }
end

p ["an", "abc", "xyza"].my_none? { |x| x.length >= 4 }
