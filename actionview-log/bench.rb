require 'rails'
require 'action_view'
require 'action_view/log_subscriber'
require 'tempfile'

event_name    = 'render_template.action_view'
event_id      = '96b113bbc01cd10dece9'
event_payload = { identifier: '/home/k0kubun/src/github.com/k0kubun/railsbench/app/views/posts/show.html.erb', layout: 'layouts/application' }
event = ActiveSupport::Notifications::Event.new(event_name, 57118.032488197, 57118.032936073, event_id, event_payload)

f = Tempfile.new('actionview-log')
ActionView::Base.logger = Logger.new(f)

subscriber = ActionView::LogSubscriber.new
if RubyVM::MJIT.enabled?
  # --jit-wait
  i = 0
  while i < 10000
    subscriber.start(event_name, event_id, event_payload)
    subscriber.render_template(event)
    i += 1
  end
else
  subscriber.start(event_name, event_id, event_payload)
  subscriber.render_template(event)
end

puts "=="

t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
i = 0
while i < 100000
  subscriber.start(event_name, event_id, event_payload)
  subscriber.render_template(event)
  i += 1
end
puts(Process.clock_gettime(Process::CLOCK_MONOTONIC) - t)
