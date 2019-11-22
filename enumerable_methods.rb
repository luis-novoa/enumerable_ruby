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
  def my_inject(initial = nil, sym = nil, &proc)
    operations = {
      :+ => proc { |a, b| a + b },
      :- => proc { |a, b| a - b },
      :* => proc { |a, b| a * b },
      :/ => proc { |a, b| a / b },
      :** => proc { |a, b| a**b }
    }
    sym, initial = initial.to_sym, sym if sym.nil? && initial.respond_to?(:to_sym)
    instance = self
    instance = instance.clone
    total ||= 0
    instance.my_each do |e|
      if !sym.nil?
        puts e
        total = operations[sym].call(total, e)
      else
        total = yield(total, e) || proc.call(total, e)
      end
    end
    total
  end
  # def my_inject(initial = nil, sym = nil, &proc)
  #   if initial.class == (Symbol || String) && sym.nil? && !block_given?
  #     sym = initial
  #     initial = nil
  #   elsif initial.class == (Symbol || String) && sym.class == (Symbol || String)
  #     raise "undefined method `#{sym}' for #{inspect initial}"
  #   end
  #   instance = self
  #   instance = instance.clone
  #   total = initial
  #   total = instance.shift if total.nil?
  #   operations = {
  #     :+ => proc { |a, b| a + b },
  #     :- => proc { |a, b| a - b },
  #     :* => proc { |a, b| a * b },
  #     :/ => proc { |a, b| a / b },
  #     :** => proc { |a, b| a**b }
  #   }
  #   if !sym.nil?
  #     sym = sym.to_sym if sym.class == String
  #     instance.each do |e|
  #       total = operations[sym].call(total, e)
  #     end
  #   elsif !proc.nil?
  #     instance.each do |e|
  #       total = proc.call(total, e)
  #     end
  #   else
  #     return instance.to_enum unless block_given?

  #     instance.each do |e|
  #       total = yield(total, e)
  #     end
  #   end
  #   total
  # end

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

array = [1,2,5,4,7]
p array.my_inject(:+) == array.inject(:+)
p array.my_inject(:+)
# array.my_inject(1) do |sum, e|
#   sum + e
# end