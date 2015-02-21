class Array
  def my_inject(accumulator = nil, &prc)
    i = 0

    if accumulator.nil?
      accumulator = self.first
      i += 1
    end

    while i < self.length
      accumulator = prc.call(accumulator, self[i])
      i += 1
    end

    accumulator
  end
end

def is_prime?(num)
  (2...num).none? { |factor| num % factor == 0 }
end

def primes(count)
  return [] if count == 0

  primes_array = []
  number = 2
  counter = 0

  while counter < count
    if is_prime?(number)
      primes_array << number
      counter += 1
    end
    number += 1
  end

  primes_array
end

# the "calls itself recursively" spec may say that there is no method
# named "and_call_original" if you are using an older version of
# rspec. You may ignore this failure.
# Also, be aware that the first factorial number is 0!, which is defined
# to equal 1. So the 2nd factorial is 1!, the 3rd factorial is 2!, etc.
def factorials_rec(num)
  if num == 1
    [1]
  else
    factorials_rec(num - 1) << (num - 1) * factorials_rec(num - 1)[-1]
  end
end

class Array

  def dups
    dups_hash = Hash.new { |hash, key| hash[key] = []}

    self.each_with_index do |value, index|
      if self.count(value) > 1
        dups_hash[value] << index
      end
    end

    dups_hash
  end

end

class String
  def symmetric_substrings
    sym_substrings = []

     (0..(self.length - 2)).each do |str_start|
       ((str_start + 1)..(self.length - 1)).each do |str_end|
        if self[str_start..str_end].reverse == self[str_start..str_end]
          sym_substrings << self[str_start..str_end]
        end
      end
    end

    sym_substrings
  end
end

class Array
  def merge_sort(&prc)
    if self.empty?
      []
    elsif self.count == 1
      self
    else
      self.merge()
    end
  end

  private
  def self.merge(left, right, &prc)
     if !prc.nil?
       prc.call(left, right)
     end
  end
end
