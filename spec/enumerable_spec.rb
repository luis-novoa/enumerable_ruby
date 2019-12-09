# frozen_string_literal: true

require File.expand_path('../enumerable_methods', __dir__)

RSpec.describe do
  describe 'my_each' do
    let(:array) {[1, 2, 3, 4]}
    let(:new_array) {[]}
      it 'applies adds one to every element' do
        array.my_each do |e| new_array.push(e += 1) end
      expect(new_array).to eq([2, 3, 4, 5])
    end
  end
end