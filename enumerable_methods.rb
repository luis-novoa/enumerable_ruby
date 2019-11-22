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
    if !type.nil?
      raise 'warning: given block not used' if block_given?

      instance.my_each do |e|
        return false if e == type || (type.match(e) if defined?(type.match) && e.respond_to?(:match)) || e.class == type
      end
    elsif block_given?
      instance.my_each do |e|
        return false if yield(e)
      end
    else
      instance.my_each do |e|
        return false unless e == true
      end
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

  def my_inject(initial = 0, sym = nil, &proc)
    operations = {
      :+ => proc { |a, b| a + b },
      :- => proc { |a, b| a - b },
      :* => proc { |a, b| a * b },
      :/ => proc { |a, b| a / b },
      :** => proc { |a, b| a**b }
    }
    total = initial
    sym, total = initial.to_sym, sym if sym.nil? && initial.respond_to?(:to_sym)
    total ||= 0
    instance = self
    instance = instance.clone
    instance.my_each do |e|
      if operations.include?(sym)
        total = operations[sym].call(total, e)
      elsif block_given? || !proc.nil?
        total = proc.call(total, e) || yield(total, e)
      end
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
