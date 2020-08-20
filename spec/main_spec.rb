require_relative '../main.rb'

describe Enumerable do
  let(:test_array) { [20, 3, 12, 7, 15] }
  let(:test_range) { (1..9) }

  describe '#my_each' do
    context 'when called with a &block' do
      it 'returns an array when called on an array' do
        expect(test_array.my_each { }).to eq(test_array.each { })
      end

      it 'returns a range when called on a range' do
        expect(test_range.my_each { }).to eq(test_range.each { })
      end

      context 'not equal' do
        it 'returns true when compairing result of array and range' do
          expect(test_array.my_each { }).not_to eq(test_range.each { })
        end
      end
    end

    context 'when called without a &block' do
      it 'returns an array enumerator when called on an array' do
        expect(test_array.my_each.class).to eq(test_array.each.class)
      end

      it 'returns a range enumerator when called on a range' do
        expect(test_range.my_each.class).to eq(test_range.each.class)
      end

      context 'not equal' do
        it 'returns true when compairing same array result' do
          expect(test_range.my_each).not_to eq(test_range.each)
        end
      end
    end
  end

  describe '#my_each_with_index' do
  end
end
