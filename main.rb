module Enumerable
    def my_each
      return enum_for unless block_given?
      for e in self
        yield e
      end
    end
end
