require 'zlib'
require 'base64'

class ProfilePostProcessorWorker
  include Sidekiq::Worker
  sidekiq_options queue: :profile_post_processor_worker

  def perform(args={})
    operation = Operation.where(uuid: args.fetch('operation_uuid')).first!
    profile_data_base64 = args.fetch('profile_data_base64')
    profile_url = args.fetch('profile_url')

    raw_json = Zlib::Inflate.inflate(Base64.decode64(profile_data_base64)).force_encoding('utf-8')

    parser = ProfileParser.new(profile_view: JSON.parse(raw_json))

    profile = Profile.where(url: profile_url).first_or_initialize
    profile.raw_data = raw_json
    profile.parsed_data = parser.to_json
    profile.save!

    # Finally:
    Rails.application.redis.decr(operation.job_counter_key)
    OperationFinishedWorker.perform_async(operation_uuid: operation.uuid)
  end

end
