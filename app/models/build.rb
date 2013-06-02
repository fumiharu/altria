class Build < PositiveRecord::Base
  validates :id, presence: true
  validates :job_id, presence: true

  property :id
  property :job_id

  belongs_to :job

  def initialize(attributes = {})
    @attributes = attributes.with_indifferent_access
  end

  # Creates, queues, and returns itself.
  def self.create_with_queue(*args)
    create(*args).tap(&:queue)
  end

  # Pushes this build to worker's queue.
  def queue
    BuildWorker.perform_async(id)
  end

  # Runs this build, usually called from BuildWorker#perform.
  def run
    start
    status = job.run
    finish(status)
  end

  def pathname
    job.pathname.dirname.join("builds/#{id}/attributes.yml")
  end

  private

  # Marks started_at.
  def start
    update_attributes!(started_at: Time.now)
  end

  # Marks finished_at and status. The status is usually a ret-val of Job#run.
  def finish(status)
    update_attributes!(finished_at: Time.now, status: status)
  end
end
