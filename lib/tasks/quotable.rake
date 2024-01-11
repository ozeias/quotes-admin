namespace :maintenance do
  desc 'Enqueue a job to process data from quotable'
  task quotable: [ :environment ] do
    QuotableJob.perform_now
  end
end
