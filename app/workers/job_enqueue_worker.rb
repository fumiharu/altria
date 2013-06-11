class JobEnqueueWorker
  @queue = name

  class << self
    def perform(id)
      Job.find(id).enqueue_with_before_hooks
    end

    def perform_async(id)
      Resque.enqueue(self, id)
    end
  end
end
