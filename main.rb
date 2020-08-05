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
end
