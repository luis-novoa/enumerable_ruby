# frozen_string_literal: true

require_relative '../enumerable_methods'

RSpec.describe do
  shared_context 'global_arrays' do
    let(:array) { [1, 2, 3, 4] }
    let(:new_array) { [] }
  end

  describe '#my_each' do
    include_context 'global_arrays' do
      it 'applies adds one to every element' do
        array.my_each do |e|
          e += 1
          new_array.push(e)
        end
        expect(new_array).to eq([2, 3, 4, 5])
      end

      it 'returns en enumerable when no block is passed' do
        expect(array.my_each.class).to eq(Enumerator)
      end
    end
  end

  describe '#my_select' do
    include_context 'global_arrays' do
      it 'returns all numbers bigger than two' do
        new_array = array.my_select { |n| n > 2 }
        expect(new_array).to eq([3, 4])
      end

      it 'returns en enumerable when no block is passed' do
        new_array = array.my_select
        expect(new_array.class).to eq(Enumerator)
      end
    end
  end

  describe '#my_all?' do
    include_context 'global_arrays' do
      it 'returns true for the array of Integers' do
        expect(array.my_all?(Integer)).to eq(true)
      end

      it 'returns error if more than one argument is given' do
        expect{ array.my_all?(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#my_any?' do
    include_context 'global_arrays' do
      it 'returns false because there\'s no string' do
        expect(array.my_any?(String)).to eq(false)
      end

      it 'returns error if more than one argument is given' do
        expect{ array.my_any?(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#my_none?' do
    include_context 'global_arrays' do
      it 'returns true because there\'s no arrays' do
        expect(array.my_none?(Array)).to eq(true)
      end

      it 'returns error if more than one argument is given' do
        expect{ array.my_none?(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#my_inject' do

    include_context 'global_arrays' do
      it 'returns the sum of the array' do
        expect(array.my_inject(:+)).to eq(10)
      end

      it 'raises an error when no block is given' do
        expect{ array.my_inject }.to raise_error(LocalJumpError)
      end
    end
  end
end