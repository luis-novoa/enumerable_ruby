# frozen_string_literal: true

module Enumerable
  def my_each
    instance = self
    if block_given?
      for i in 0...instance.length
        yield(instance[i])
      end
    else
      instance.to_enum
    end
  end

  def my_each_with_index
    instance = self
    if block_given?
      for i in 0...instance.length
        yield(instance[i], i)
      end
    else
      instance.to_enum
    end
  end

  def my_select
    instance = self
    result = []
    if block_given?
      instance.my_each do |e|
        result.push(e) if yield(e)
      end
      result
    else
      instance.to_enum
    end
  end

  def my_all?(type = nil)
    instance = self
    result = true
    if !type.nil?
      raise 'warning: given block not used' if block_given?

      instance.my_each do |e|
        unless e == type || e.match(type) || e.class == type
          result = false
          break
        end
      end
      result
    elsif block_given?
      instance.my_each do |e|
        unless yield(e)
          result = false
          break
        end
      end
      result
    else
      instance.to_enum
    end
  end

  def my_any?(type = nil)
    instance = self
    result = false
    if !type.nil?
      raise 'warning: given block not used' if block_given?

      instance.my_each do |e|
        if e == type || e.match(type) || e.class == type
          result = true
          break
        end
      end
      result
    elsif block_given?
      instance.my_each do |e|
        if yield(e)
          result = true
          break
        end
      end
      result
    else
      instance.to_enum
    end
  end

  def my_none?(type = nil)
    instance = self
    result = true
    if !type.nil?
      raise 'warning: given block not used' if block_given?
      
      instance.my_each do |e|
        if e == type || e.match(type) || e.class == type
          result = false
          break
        end
      end
      result
    elsif block_given?
      instance.my_each do |e|
        if yield(e)
          result = false
          break
        end
      end
      result
    else
      instance.to_enum
    end
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
    if block_given?
      instance.my_each do |e|
        result.push(yield(e))
      end
      result
    else
      instance.to_enum
    end
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
      total
    elsif block_given?
      instance.each do |e|
        total = yield(total, e)
      end
      total
    else
      instance.to_enum
    end
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
    if block_given?
      instance.my_each do |e|
        result.push(proc.call(e))
      end
      result
    else
      instance.to_enum
    end
  end

  def my_map_procblock(&proc)
    instance = self
    result = []
    if block_given?
      instance.my_each do |e|
        if proc.nil?
          result.push(yield(e))
        else
          result.push(proc.call(e))
        end
      end
      result
    else
      instance.to_enum
    end
  end
end

# var = [1, 4, 3, 4]
# inst = Proc.new do |e| e += 1 end
# test = var.my_inject(:+)
# puts test