require File.expand_path("../../config/environment.rb", __FILE__)

Clockwork.every(1.minute, "Job.enqueue") do
  Job.enqueue
end
