require 'action_view'
require 'action_controller'

erb = "<% #{<<~"begin;"}\n#{<<~"end;"} %>"
begin;
  if RubyVM::MJIT.enabled?
    # --jit-wait
    i = 0
    while i < 10000
      csrf_meta_tags
      i += 1
    end
  else
    csrf_meta_tags
  end

  puts "=="

  t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  i = 0
  while i < 100000
    csrf_meta_tags
    i += 1
  end
  puts(Process.clock_gettime(Process::CLOCK_MONOTONIC) - t)
end;

env = Rack::MockRequest.env_for('/posts/1', method: Rack::GET)
controller = ActionController::Base.new
controller.set_request!(ActionDispatch::Request.new(env))
controller.render_to_body(inline: erb, type: :erb)
