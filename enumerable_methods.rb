# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength

module Enumerable
  def my_each
    instance = self
    instance = instance.clone
    return instance.to_enum if !block_given? || instance.length.zero?

    i = 0
    loop do
      yield(instance[i])
      i += 1
      break if i == instance.length
    end
  end

  def my_each_with_index
    instance = self
    instance = instance.clone
    return instance.to_enum unless block_given?

    i = 0
    loop do
      yield(instance[i], i)
      i += 1
      break if i == instance.length
    end
  end

  def my_select
    instance = self
    instance = instance.clone
    result = []
    return instance.to_enum unless block_given?

    instance.my_each do |e|
      result.push(e) if yield(e)
    end
    result
  end

  def empty_array?(length)
    true if length.zero?
  end

  def my_all?(type = [])
    instance = self
    instance = instance.clone
    empty = type.empty? if type.respond_to?(:empty?)
    puts 'warning: given block not used' if block_given? && !empty
    empty_array?(instance.length)

    instance.my_each do |e|
      is_true = truthy(e, type)
      is_true ||= truthy_no_typeblock(e, empty, !block_given?)
      if block_given?
        return false unless yield(e)

        is_true ||= true
      end
      return false unless is_true
    end
    true
  end

  def my_any?(type = [])
    instance = self
    instance = instance.clone
    empty = type.empty? if type.respond_to?(:empty?)
    puts 'warning: given block not used' if block_given? && !empty
    !instance.my_none?(type)
  end

  def my_none?(type = [])
    instance = self
    instance = instance.clone
    empty = type.empty? if type.respond_to?(:empty?)
    puts 'warning: given block not used' if block_given? && !empty
    instance.my_each do |e|
      is_true = truthy_no_typeblock(e, empty, !block_given?)
      is_true ||= truthy(e, type)
      return false if is_true
      return false if block_given? && yield(e)
    end
    true
  end

  def my_count(arg = nil, &proc)
    instance = self
    instance = instance.clone
    if !arg.nil?
      puts 'warning: given block not used' unless proc.nil?
      count = 0
      instance.my_each do |e|
        count += 1 if e == arg
      end
      count
    elsif !proc.nil?
      count = 0
      instance.my_each do |e|
        count += 1 if proc.call(e)
      end
      count
    else
      instance.length
    end
  end

  def my_map
    instance = self
    instance = instance.clone
    result = []
    return instance.to_enum unless block_given?

    instance.my_each do |e|
      result.push(yield(e))
    end
    result
  end

  def my_inject(initial = nil, sym = nil)
    operations = {
      :+ => proc { |a, b| a + b },
      :- => proc { |a, b| a - b },
      :* => proc { |a, b| a * b },
      :/ => proc { |a, b| a / b },
      :** => proc { |a, b| a**b }
    }
    instance = self
    instance = instance.clone.to_a
    if sym.nil? && initial.respond_to?(:to_sym)
      sym = initial.to_sym
      initial = nil
    end
    total = initial
    total = instance.shift if initial.nil?
    instance.my_each do |e|
      total = operations[sym].call(total, e) unless sym.nil?
      total = yield(total, e) if block_given?
    end
    total
  end

  def multiply_els
    instance = self
    instance = instance.clone
    instance.my_inject do |sum, e|
      sum * e
    end
  end

  def my_map_proc(&proc)
    instance = self
    instance = instance.clone
    result = []
    return instance.to_enum unless block_given?

    instance.my_each do |e|
      result.push(proc.call(e))
    end
    result
  end

  def my_map_procblock(&proc)
    instance = self
    instance = instance.clone
    result = []
    return instance.to_enum unless block_given?

    instance.my_each do |e|
      if proc.nil?
        result.push(yield(e))
      else
        result.push(proc.call(e))
      end
    end
    result
  end
end

def truthy(element, sample)
  reg = sample.match(element) if defined?(sample.match) && element.respond_to?(:match)
  return true if reg || element == sample || element.class == sample

  truthy_numeric(element, sample)
end

def truthy_numeric(element, sample)
  return true if sample == Numeric && element.is_a?(Numeric)
end

def truthy_no_typeblock(element, no_type, no_block)
  return true if element && no_type && no_block
end

p %w{ant bear cat}.my_none?(/d/)

# rubocop:enable Metrics/ModuleLength
