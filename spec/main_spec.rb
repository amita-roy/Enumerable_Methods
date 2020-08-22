require_relative '../main.rb'
require_relative 'shared_context'

describe Enumerable do
  let(:test_array) { [20, 3, 12, 7, 15] }
  let(:string_array) { %w[cat passion boolean possibility] }
  let(:test_range) { (1..9) }
  let(:test_hash) { { 'cat' => 'meow', 'dog' => 'bark' } }
  let(:test_block) { proc { |e| e.even? } }

  before_context

  ending_after_context

  describe '#my_each' do
    after_context('#my_each_with_index')

    context 'when called with a &block' do
      it 'returns an array when called on an array' do
        expect(test_array.my_each { test_block }).to eq(test_array.each { test_block })
      end

      it 'returns a range when called on a range' do
        expect(test_range.my_each { test_block }).to eq(test_range.each { test_block })
      end
    end

    context 'when called without a &block' do
      it 'returns an array enumerator when called on an array' do
        expect(test_array.my_each.class).to eq(test_array.each.class)
      end

      it 'returns a range enumerator when called on a range' do
        expect(test_range.my_each.class).to eq(test_range.each.class)
      end
    end

    context 'covers negative tests' do
      it 'throws argument error when called with an argument' do
        expect { ['st', 'tt', 23].my_each(3) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#my_each_with_index' do
    after_context('#my_select')

    context 'when called with a &block' do
      it 'returns the original array when called on an array' do
        expect(test_array.my_each_with_index { test_block }).to eql(test_array)
      end
      it 'returns the range itself when called on a range' do
        expect(test_range.my_each_with_index { test_block }).to eql(test_range)
      end

      it 'returns the hash itself when called on a hash' do
        expect(test_hash.my_each_with_index { test_block }).to eql(test_hash)
      end

      context 'returns the same result like #each_with_index' do
        it do
          original_each_test = test_array.each_with_index { |e, i| e + i }
          expect(test_array.my_each_with_index { |e, i| e + i }).to eql(original_each_test)
        end
      end

      context 'covers negative tests' do
        it 'throws argument error when called with an argument' do
          expect { ['st', 'tt', 23].my_each(3) }.to raise_error(ArgumentError)
        end

        it 'throws TypeError when called on a hash of string and integer' do
          expect { { cat: 23, dog: 43 }.each_with_index { |e, i| puts e + i } }.to raise_error(TypeError)
        end
      end
    end

    context 'when called without a &block' do
      it 'returns an array enumerator when called on an array' do
        expect(test_array.my_each).to be_instance_of(Enumerator)
      end
      it 'returns a range enumerator when called on a range' do
        expect(test_range.my_each).to be_instance_of(Enumerator)
      end
    end
  end

  describe '#my_select' do
    after_context('#my_all?')

    context 'when called with a &block' do
      it 'returns an array of elements yield true when called on array' do
        test = test_array.select { |e| e > 3 }
        expect(test_array.my_select { |e| e > 3 }).to eq(test)
      end

      it 'returns an array of elements yield true when called on range' do
        test = test_range.select { |e| e > 5 }
        expect(test_range.my_select { |e| e > 5 }).to eq(test)
      end

      it 'not to be a nil when called on an empty array' do
        expect([].my_select { |e| e > 5 }).not_to be nil
      end
    end

    context 'when called without a &block' do
      it 'returns an array enumerator when called on an array' do
        expect(test_array.my_select).to be_instance_of(Enumerator)
      end
    end

    context 'covers negative tests' do
      it 'throws argument error when called with an argument' do
        expect { { cat: 23, dog: 43 }.my_select(3) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#my_all?' do
    after_context('#my_any?')

    context 'when called with only an argument' do
      it 'returns true if all the elements in the array eql argument, else false' do
        expect(test_array.my_all?(Numeric)).to eql(test_array.all?(Numeric))
      end

      it 'returns true if all the elements in the range eql argument, else false' do
        expect(test_range.my_all?(3)).to eql(test_range.all?(3))
      end
    end

    context 'when called with only &block' do
      it 'returns true if all elements in the array yield true' do
        expect(test_array.my_all? { test_block }).to eql(test_array.all? { test_block })
      end

      it 'returns true if all elements in the range yield true' do
        expect(test_range.my_all? { test_block }).to eql(test_range.all? { test_block })
      end
    end

    context 'when called with no block and no argument' do
      it 'return true if all the element in the array are truthy else false' do
        expect(test_array.my_all?).to eql(test_array.all?)
      end

      it 'return true if all the element in the range are truthy else false' do
        expect(test_range.my_all?).to eql(test_range.all?)
      end

      it 'should not return false if called on an empty array' do
        expect([].my_all?).not_to be(false)
      end
    end

    context 'when called with a block and an argument' do
      it 'neglects the block and use the argument' do
        expect(test_array.my_all?(3) { test_block }).to eql(test_array.all?(3) { test_block })
      end
    end

    context 'when pattern/regex doesn\'t match' do
      it 'return false if every element in the array doesn\'t match with pattern ' do
        mixed_array = ['that', 'cat', 23, 'mat', true]
        expect(mixed_array.my_all?(/at/)).to eql(mixed_array.all?(/at/))
      end
    end

    context 'covers negative tests' do
      it 'throws NoMethodError when called with an argument' do
        expect { { cat: 23, dog: 43 }.my_all? { |e| e > 5 } }.to raise_error(NoMethodError)
      end
    end
  end

  describe '#my_any?' do
    after_context('#my_none?')

    context 'when called with no &block and no argument' do
      it 'returns true if any elements of the array is truthy, else false' do
        expect(test_array.my_any?).to eql(test_array.any?)
      end

      it 'returns true if any elements in the range is truthy, else false' do
        expect(test_range.my_any?).to eql(test_range.any?)
      end

      it 'should not return true if called on an empty array like #my_all?' do
        expect([].any?).not_to be(true)
      end
    end

    context 'when called with only an argument' do
      it 'returns true if any of the elements in the array eql argument, else false' do
        expect(test_array.my_any?(String)).to eql(test_array.any?(String))
      end

      it 'returns true if any of the elements in the range eql argument, else false' do
        expect(test_range.my_any?(4)).to eql(test_range.any?(4))
      end
    end

    context 'when called with only a &block' do
      it('returns true if any element yield true in the array, else false') do
        expect(test_array.my_any? { test_block }).to(eql(test_array.any? { test_block }))
      end
    end

    context 'when called with an argumenta and a &block ' do
      it 'use the argument and neglects the block' do
        expect(test_array.my_any?(3) { test_block }).to eql(test_array.any?(3) { test_block })
      end
    end
  end

  describe '#my_none?' do
    after_context('#my_count')

    context 'when called with no argument and no &block' do
      it 'returns false if any of the element is truthy, else true' do
        expect(test_array.my_none?).to eql(test_array.none?)
      end

      it 'returns false if any of the element in the range is truthy, else true' do
        expect(test_range.my_none?).to eql(test_range.none?)
      end

      it 'should not return false when called on an empty array' do
        expect([].my_none?).not_to be(false)
      end
    end

    context 'when called with only an argument' do
      it 'returns true if none of the elements in the array is truthy, else false' do
        expect(test_array.my_none?(Numeric)).to eql(test_array.none?(Numeric))
      end

      it 'returns true if none of the elements in the range is truthy, else false' do
        expect(test_range.my_none?(4)).to eql(test_range.none?(4))
      end

      it 'evalutes to true if none matches a pattern' do
        expect(%w[dog butterfly mouse].my_none?(/a/)).to be true
      end
    end

    context 'when called with only a &block' do
      it 'returns true if none of the element in the array yield true, else false' do
        expect(test_array.my_none? { test_block }).to eql(test_array.none? { test_block })
      end
    end

    context('when called with a block and an argument') do
      it 'use the argument and neglects the &block' do
        expect(test_array.my_none?(44) { test_block }).to eql(test_array.none?(44) { test_block })
      end
    end
  end

  describe '#my_count' do
    after_context('#my_map')

    context 'when called with no argument and no $block' do
      it 'returns the length of the array' do
        expect(test_array.my_count).to eql(test_array.length)
      end
    end

    context 'when called with only an argument' do
      it 'returns the count of the element in the array that is eql to argument' do
        expect([2, 3, 5, 2, 4].my_count(2)).to eql(2)
      end

      it 'returns the count of the element in the array that is eql to argument' do
        expect([2, 3, 5, 2, 4].my_count(2)).to eql(2)
      end
    end

    context 'when called with only a &block' do
      it 'returns the count of element in the array for which block yields true' do
        expect([2, 3, 5, 2, 4].my_count { |e| e > 3 }).to eql(2)
      end
    end

    context 'when called with a block and an argument' do
      it 'use the argument and neglects the block' do
        expect([2, 3, 5, 2, 4].my_count(4) { |e| e > 3 }).to eql(1)
      end
    end
  end

  describe '#my_map' do
    after_context('#my_inject')
    let(:pr) { proc { |num| num < 5 } }

    context 'when no &block given' do
      it 'returns an array enumerator' do
        expect(test_array.my_map).to be_instance_of(Enumerator)
      end
    end

    it 'returns a new array' do
      expect(test_array.my_map { |e| e * 2 }).to eql([40, 6, 24, 14, 30])
    end

    it 'returns a new array with the executed proc' do
      expect(test_array.my_map(&pr)).to eql(test_array.map(&pr))
    end

    context 'covers negative tests' do
      it 'throws NoMethodError when called with an argument not proc' do
        expect { ['st', 'tt', 23].my_map(3) }.to raise_error(NoMethodError)
      end
    end
  end

  describe '#my_inject' do
    context 'when no argument and no $block given' do
      it 'raise localjumperror' do
        expect { test_array.my_inject }.to raise_error(LocalJumpError)
      end
    end

    it 'when 2 arguments provided and one of them is a symbol' do
      expect(test_array.my_inject(1, :*)).to eq(756_00)
    end

    context 'when only one argument provided' do
      it 'return the sum of all the element in the array if argument is a  :+ symbol' do
        expect([1, 2, 3].my_inject(:+)).to eq([1, 2, 3].inject(:+))
      end

      context 'covers negative test cases' do
        it 'raise a TypeError if provided argument is not a symbol nor a string' do
          expect { test_array.my_inject(2) }.to raise_error(TypeError)
        end

        it 'raise a TypeError when called on a hash of string and number' do
          expect { { cat: 23, dog: 43 }.my_inject(2, :+) }.to raise_error(TypeError)
        end
      end
    end

    context 'when one argument and a &block provided' do
      it 'return the result as per the condition provided in the block and argument act as an accumulator' do
        expect([1, 2, 3].my_inject(2) { |e, n| e + n }).to eq(8)
      end
    end
  end
end
