#!/usr/bin/env ruby

require 'benchmark'
require 'async'
require 'async/barrier'
require 'async/semaphore'

CONCURRENT_TASKS = 20
# 5 times the load
CONCURRENT_LOAD = 5_000_000

class Counter
  attr_accessor :count, :even_count

  def initialize
    @count = 0
    @even_count = 0
  end

  def increment
    @count += 1
  end

  def +(other)
    counter = Counter.new
    counter.count = @count + other.count
    counter.even_count = @even_count + other.even_count
    counter
  end
end

# FIBERS
f_counter = Counter.new
fiber_time = Benchmark.measure do
    Sync do
    barrier = Async::Barrier.new

    CONCURRENT_TASKS.times.each do |_|
      barrier.async do |_|
        CONCURRENT_LOAD.times do
          f_counter.increment
          f_counter.even_count += 1 if f_counter.count.even?
        end
      end 
    end

    barrier.wait
  end
end.real

# RACTORS
r_counter = Counter.new
ractor_time = Benchmark.measure do
  counters = CONCURRENT_TASKS.times.map do |i|
    Ractor.new(i) do |i|
      counter = Counter.new
      CONCURRENT_LOAD.times do
        counter.increment
        counter.even_count += 1 if counter.count.even?
      end
      counter
    end
  end.map(&:take)
  r_counter = counters.inject(:+)
end.real

puts "Fibers: \t#{f_counter.count}, #{f_counter.even_count}, #{fiber_time.round(3)}"
puts "Ractors: \t#{r_counter.count}, #{r_counter.even_count}, #{ractor_time.round(3)}"

puts "Difference:\t#{r_counter.count-f_counter.count}, #{r_counter.even_count - f_counter.even_count}, #{(ractor_time/fiber_time*100).round(2)}%" 
