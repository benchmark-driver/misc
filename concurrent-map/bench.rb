# Usage:
#   CACHE=0 ruby bench.rb
#   CACHE=1 ruby bench.rb
require 'bundler/setup'
require 'action_view'

map_key = :en
map = Concurrent::Map.new
map[map_key] = Object.new

# ENV['CACHE'] ||= '1'

if ENV['CACHE'] == '1'
  cache_key = 'show'
  cache = ActionView::Resolver::Cache::SmallCache.new
  cache[cache_key] = Object.new

  i = 0
  while i < 10000
    cache[cache_key]
    i += 1
  end
end

if RubyVM::MJIT.enabled?
  15.times { sleep 0.1 }
  puts "compile1"
end

i = 0
while i < 10000
  map[map_key]
  i += 1
end

if RubyVM::MJIT.enabled?
  15.times { sleep 0.1 }
  puts "compile2"
end

puts "--"

t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
i = 0
while i < 20000000
  map[map_key]
  i += 1
end
puts(Process.clock_gettime(Process::CLOCK_MONOTONIC) - t)
