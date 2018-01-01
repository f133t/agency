
class OperationFinishedWorker
  include Sidekiq::Worker
  sidekiq_options queue: :operation_finished_worker

  def perform(args={})
    operation = Operation.where(uuid: args.fetch('operation_uuid')).first!
    return unless Rails.application.redis.get(operation.job_counter_key).to_i <= 0

    # Resulting data goes back to the requestor:
    # TODO

    # Finally:
    operation.update_attributes!(finished_at: Time.now)
  end

end
