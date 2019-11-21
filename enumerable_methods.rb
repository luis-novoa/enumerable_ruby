# frozen_string_literal: true

module Enumerable
  def my_each
    instance = self
    return instance.to_enum unless block_given?

    for i in 0...instance.length
      yield(instance[i])
    end
  end

  def my_each_with_index
    instance = self
    return instance.to_enum unless block_given?

    for i in 0...instance.length
      yield(instance[i], i)
    end
  end

  def my_select
    instance = self
    result = []
    return instance.to_enum unless block_given?

    instance.my_each do |e|
      result.push(e) if yield(e)
    end
    result
  end

  def my_all?(type = nil)
    instance = self
    if !type.nil?
      raise 'warning: given block not used' if block_given?

      instance.my_each do |e|
        return false unless e == type || (type.match(e) if (defined?(type.match) && e.respond_to?(:match))) || e.class == type
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
    if !type.nil?
      raise 'warning: given block not used' if block_given?

      instance.my_each do |e|
        return true if e == type || (type.match(e) if (defined?(type.match) && e.respond_to?(:match))) || e.class == type
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
    if !type.nil?
      raise 'warning: given block not used' if block_given?

      instance.my_each do |e|
        return false if e == type || (e.match(type) if e.is_a?(String || Symbol)) || e.class == type
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

  def my_count(arg = nil)
    instance = self
    if !arg.nil?
      count = 0
      instance.my_each do |e|
        count += 1 if e == arg
      end
      count
    else
      instance.length
    end
  end

  def my_map
    instance = self
    result = []
    return instance.to_enum unless block_given?

    instance.my_each do |e|
      result.push(yield(e))
    end
    result
  end

  def my_inject(initial = nil, sym = nil)
    if initial.class == (Symbol || String) && sym.nil? && !block_given?
      sym = initial
      initial = nil
    elsif initial.class == (Symbol || String) && sym.class == (Symbol || String)
      raise "undefined method `#{sym}' for #{inspect initial}"
    end
    instance = self
    total = initial
    total = instance.shift if total.nil?
    operations = {
      :+ => proc { |a, b| a + b },
      :- => proc { |a, b| a - b },
      :* => proc { |a, b| a * b },
      :/ => proc { |a, b| a / b },
      :** => proc { |a, b| a**b }
    }
    if !sym.nil?
      sym = sym.to_sym if sym.class == String
      instance.each do |e|
        total = operations[sym].call(total, e)
      end
    else
      return instance.to_enum unless block_given?

      instance.each do |e|
        total = yield(total, e)
      end
    end
    total
  end

  def multiply_els
    instance = self
    instance.my_inject do |sum, e|
      sum * e
    end
  end

  def my_map_proc(&proc)
    instance = self
    result = []
    return instance.to_enum unless block_given?

    instance.my_each do |e|
      result.push(proc.call(e))
    end
    result
  end

  def my_map_procblock(&proc)
    instance = self
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

array = [1,2,5,4,7]
p array.my_none?(Integer) == array.none?(Integer)
#p "#my_any and #my_all recognize all classes".length