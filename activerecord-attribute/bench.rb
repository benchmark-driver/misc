require 'active_record'

ActiveRecord::Base.establish_connection(
  # k0kubun/railsbench
  adapter: 'postgresql',
  encoding: 'unicode',
  pool: 5,
  user: 'k0kubun',
  database: 'railsbench_production',
)

class Post < ActiveRecord::Base
end

post = Post.find(1)
lazy_hash = post.instance_variable_get(:@attributes).instance_variable_get(:@attributes)

if RubyVM::MJIT.enabled?
  # --jit-wait
  i = 0
  while i < 10000
    post.id
    post.title
    post.body
    post.published
    lazy_hash.instance_variable_set(:@delegate_hash, {})
    i += 1
  end
end

puts post.id
puts post.title
puts post.body
puts post.published
lazy_hash.instance_variable_set(:@delegate_hash, {})

puts "=="

t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
i = 0
while i < 100000
  post.id
  post.title
  post.body
  post.published
  lazy_hash.instance_variable_set(:@delegate_hash, {})
  i += 1
end
puts(Process.clock_gettime(Process::CLOCK_MONOTONIC) - t)
