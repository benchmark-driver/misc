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
while i < 100000
  Post.find(1)
  i += 1
end
puts(Process.clock_gettime(Process::CLOCK_MONOTONIC) - t)
