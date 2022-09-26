#!/usr/bin/env ruby

require 'benchmark'
require 'async'
require 'async/barrier'
require 'async/semaphore'

CONCURRENT_TASKS = 20
CONCURRENT_LOAD = 1_000_000

class Counter
  attr_accessor :count, :even_count

  def initialize
    @count = 0
    @even_count = 0
  end

  def increment
    @count += 1
  end
end

# THREADS
t_counter = Counter.new
thread_time = Benchmark.measure do
  CONCURRENT_TASKS.times.map do |_|
    Thread.new {
      CONCURRENT_LOAD.times do
        t_counter.increment
        t_counter.even_count += 1 if t_counter.count.even?
      end
    }
  end.map(&:join)
end.real

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

puts "Threads:\t#{t_counter.count}, #{t_counter.even_count}, #{thread_time.round(3)}"
puts "Fibers: \t#{f_counter.count}, #{f_counter.even_count}, #{fiber_time.round(3)}"

puts "Difference:\t#{f_counter.count-t_counter.count}, #{f_counter.even_count - t_counter.even_count}, #{(fiber_time/thread_time*100).round(2)}%" 

puts "\n" * 20
