ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "rspec/autorun"
require "sidekiq/testing"

RSpec.configure do |config|
  # If you"re not using ActiveRecord, or you"d prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Enables :focus metadata filter.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.include RSpec::JsonMatcher, type: :request
  config.include ResponseCodeMatchers, type: :request

  config.before do
    Job.stub(directory: Rails.root + "spec/fixtures/jobs")
  end

  config.after do
    pathname = Rails.root + "spec/fixtures/jobs"
    pathname.rmtree
    pathname.mkdir
  end
end
