require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:',
)

ActiveRecord::Schema.define do
  create_table :posts do |t|
    t.string :title
    t.text :body
    t.boolean :published
    t.datetime :created_at, null: false
    t.datetime :updated_at, null: false
  end
end

class Post < ActiveRecord::Base
end
Post.create({ id: 1, title: "The Widening Gyre", body: "I believe consistency and orthogonality are tools of design, not the primary goal in design.", published: false })

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
