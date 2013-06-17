class EventsController < ApplicationController
  include ActionController::Live

  before_filter :require_event_stream

  def index
    redis = Redis.new
    redis.psubscribe("build.*") do |on|
      on.pmessage do |pattern, event, data|
        response.stream.write("event: #{event}\n")
        response.stream.write("data: #{data}\n\n")
      end
    end
  rescue IOError
  rescue Redis::CannotConnectError
    head 503
  ensure
    redis.quit rescue nil
    response.stream.close
  end

  private

  def index_with_redis_exception
    index_without_redis_exception
  rescue Redis::CannotConnectError
    head 503
  end
  alias_method_chain :index, :redis_exception

  def require_event_stream
    response.headers["Content-Type"] = "text/event-stream"
  end
end
