require_relative '../main.rb'

describe Enumerable do
  let(:test_array) { [20, 3, 12, 7, 15] }
  let(:test_range) { (1..9) }
  let(:test_hash) { { 'cat' => 'meow', 'dog' => 'bark' } }

  describe '#my_each' do
    context 'when called with a &block' do
      it 'returns an array when called on an array' do
        expect(test_array.my_each { }).to eq(test_array.each { })
      end

      it 'returns a range when called on a range' do
        expect(test_range.my_each { }).to eq(test_range.each { })
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
  end

  describe '#my_each_with_index' do
    context 'when called with a &block' do
      it 'returns the original array when called on an array' do
        expect(test_array.my_each_with_index { }).to eql(test_array)
      end
      it 'returns the range itself when called on a range' do
        expect(test_range.my_each_with_index { }).to eql(test_range)
      end

      it 'returns the hash itself when called on a hash' do
        expect(test_hash.my_each_with_index { }).to eql(test_hash)
      end

      context 'returns the same result like #each_with_index' do
        it do
          original_each_test = test_array.each_with_index { |e, i| e + i }
          expect(test_array.my_each_with_index { |e, i| e + i }).to eql(original_each_test)
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
end
