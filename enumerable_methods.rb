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

  def my_none?
    instance = self
    result = true
    instance.my_each do |e|
      if yield(e)
        result = false
        break
      end
    end
    result
  end

  def my_count
    instance = self
    instance.length
  end

  def my_map
    instance = self
    result = []
    instance.my_each do |e|
      result.push(yield(e))
    end
    result
  end

  def my_inject
    instance = self
    total = instance.shift
    instance.each do |e|
      total = yield(total, e)
    end
    total
  end

  def multiply_els
    instance = self
    instance.my_inject do |sum, e|
      sum * e
    end
  end
end