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

  def my_all?
    instance = self
    result = true
    if block_given?
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
    if block_given?
      instance.my_inject do |sum, e|
        sum * e
      end
    else
      instance.to_enum
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
test = var.my_each
puts test