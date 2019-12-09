# frozen_string_literal: true

require File.expand_path('../enumerable_methods', __dir__)

RSpec.describe do
  describe '#my_each' do
  let(:array) {[1, 2, 3, 4]}
  let(:new_array) {[]}
      it 'applies adds one to every element' do
        array.my_each do |e| new_array.push(e += 1) end
          expect(new_array).to eq([2, 3, 4, 5])
      end
  end
  # 
  describe '#my_select' do
  let(:arr) {[1, 2, 3, 4]}
  let(:new_arr) {[]}
    it 'returns all numbers bigger than two' do
      new_arr = arr.my_select{|n| n > 2}
      expect(new_arr).to eq([3, 4])
    end
    it 'returns en enumerable when no block is passed'do
      new_arr = arr.my_select
      expect(new_arr.class).to eq(Enumerator)
    end
  end
  # 
end
