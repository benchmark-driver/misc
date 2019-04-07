require 'rails'
require 'action_view'
require 'action_view/log_subscriber'
require 'tempfile'

event = ActiveSupport::Notifications::Event.new(
  'render_template.action_view', 57118.032488197, 57118.032936073, '96b113bbc01cd10dece9',
  { identifier: '/home/k0kubun/src/github.com/k0kubun/railsbench/app/views/posts/show.html.erb', layout: 'layouts/application' },
)
subscriber = ActionView::LogSubscriber.new

Tempfile.create do |f|
  ActionView::Base.logger = Logger.new(f)

  if RubyVM::MJIT.enabled?
    # --jit-wait
    i = 0
    while i < 10000
      subscriber.render_template(event)
      i += 1
    end
  else
    subscriber.render_template(event)
  end

  puts "=="

  t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  i = 0
  while i < 200000
    subscriber.render_template(event)
    i += 1
  end
  puts(Process.clock_gettime(Process::CLOCK_MONOTONIC) - t)
end
