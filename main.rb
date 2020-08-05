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
end
