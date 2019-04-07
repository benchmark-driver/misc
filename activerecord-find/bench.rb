require 'active_record'

# k0kubun/railsbench
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  encoding: 'unicode',
  pool: 5,
  user: 'k0kubun',
  database: 'railsbench_production',
)

class Post < ActiveRecord::Base
end

if RubyVM::MJIT.enabled?
  # --jit-wait
  i = 0
  while i < 10000
    Post.find(1)
    i += 1
  end
else
  Post.find(1)
end

puts "=="

t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
i = 0
while i < 50000
  Post.find(1)
  i += 1
end
puts(Process.clock_gettime(Process::CLOCK_MONOTONIC) - t)
