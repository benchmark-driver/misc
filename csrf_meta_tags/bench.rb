require 'action_controller'

env = Rack::MockRequest.env_for('/posts/1', method: Rack::GET)
controller = ActionController::Base.new
controller.set_request!(ActionDispatch::Request.new(env))

controller.render_to_body(inline: "<% #{<<~"begin;"}\n#{<<~"end;"} %>", type: :erb)
begin;
  if RubyVM::MJIT.enabled?
    # --jit-wait
    i = 0
    while i < 10000
      csrf_meta_tags
      i += 1
    end
  end
  puts csrf_meta_tags

  puts "=="

  t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  i = 0
  while i < 100000
    csrf_meta_tags
    i += 1
  end
  puts(Process.clock_gettime(Process::CLOCK_MONOTONIC) - t)
end;
