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
    if !(type.nil?)
      puts "warning: given block not used" if block_given?
      instance.my_each do |e|
        unless e.class == type
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

  def my_any?
    instance = self
    result = false
    if block_given?
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

  def my_none?
    instance = self
    result = true
    if block_given?
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

  def my_count
    instance = self
    if block_given?
      instance.length
    else
      instance.to_enum
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

  def my_inject
    instance = self
    total = instance.shift
    if block_given?
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

var = [1, 2, 3, 4]
inst = Proc.new do |e| e += 1 end
test = var.my_all?(String) do |e|
  e > 0
end
puts test