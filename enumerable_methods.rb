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

  def my_select
    instance = self
    result = []
    instance.my_each do |e|
      result.push(e) if yield(e)
    end
    result
  end

  def my_all?
    instance = self
    result = true
    instance.my_each do |e|
      unless yield(e)
        result = false
        break
      end
    end
    result
  end

  def my_any?
    instance = self
    result = false
    instance.my_each do |e|
      if yield(e)
        result = true
        break
      end
    end
    result
  end

end