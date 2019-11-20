# frozen_string_literal: true
# rubocop:disable Style/CaseEquality

module Enumerable
  def my_each
    instance = self
    for i in 0...instance.length
      yield(instance[i])
    end
  end

  def my_each_with_index
    instance = self
    for i in 0...instance.length
      yield(instance[i], i)
    end
  end
end