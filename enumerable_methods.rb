# frozen_string_literal: true

module Enumerable
  def my_each
    instance = self
    instance = instance.clone
    return instance.to_enum unless block_given?

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

  def my_all?(type = nil)
    instance = self
    instance = instance.clone
    if !type.nil?
      raise 'warning: given block not used' if block_given?

      instance.my_each do |e|
        if defined?(type.match) && e.respond_to?(:match)
          return false unless type.match(e)
        end
        return false unless e == type || e.class == type
      end
    elsif block_given?
      instance.my_each do |e|
        return false unless yield(e)
      end
    else
      instance.my_each do |e|
        return false if e.nil? || e == false
      end
    end
    true
  end

  def my_any?(type = nil)
    instance = self
    instance = instance.clone
    if !type.nil?
      raise 'warning: given block not used' if block_given?

      instance.my_each do |e|
        return true if e == type || (type.match(e) if defined?(type.match) && e.respond_to?(:match)) || e.class == type
      end
    elsif block_given?
      instance.my_each do |e|
        return true if yield(e)
      end
    else
      instance.my_each do |e|
        return true unless e.nil? || e == false
      end
    end
    false
  end

  def my_none?(type = nil)
    instance = self
    instance = instance.clone
    puts 'warning: given block not used' if block_given? && !type.nil?
    instance.my_each do |e|
      is_true = truthy(e, type)
      is_true ||= truthy_no_typeblock(e, type.nil?, !block_given?)
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
    instance = instance.clone
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
end

def truthy_no_typeblock(element, no_type, no_block)
  return true if element && no_type && no_block
end
