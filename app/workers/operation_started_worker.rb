
class OperationStartedWorker
  include Sidekiq::Worker
  sidekiq_options queue: :operation_started_worker

  def perform(args={})
    operation = Operation.create!(
      remote_id: args.fetch('remote_id'),
      raw_data: args.fetch('urls')
    )
    urls = JSON.parse(args.fetch('urls'))
    urls.each do |url|
      Sidekiq::Client.new.push(
        'queue' => :profile_fetcher_worker,
        'class' => 'ProfileFetcherWorker',
        'args' => [
          operation_uuid: operation.uuid,
          profile_url: url,
        ]
      )
      Rails.application.redis.incr(operation.job_counter_key)
    end
  end

end
