
class Operation < ApplicationRecord
  validates_presence_of :remote_id, :uuid, :raw_data
  before_validation :assign_uuid, on: :create
  validates_uniqueness_of :remote_id
  validates_uniqueness_of :uuid

  def job_counter_key
    'operation-job-counter:%s' % uuid
  end

  private

  def assign_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
