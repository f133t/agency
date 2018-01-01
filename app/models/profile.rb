
class Profile < ApplicationRecord
  validates_presence_of :url, :raw_data, :parsed_data

  validates_uniqueness_of :url

end
