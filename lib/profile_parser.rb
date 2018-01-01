
class ProfileParser
  # Usage:
  # => parser = ProfileParser.new('{"raw": "json", "data": "here"}')
  # => parser.to_json

  attr_accessor :profile_view

  def initialize(raw={})
    self.profile_view = raw[:profile_view]
  end

  def full_name
    [
      _profile['firstName'],
      _profile['lastName']
    ].compact.join(' ')
  end

  def headline
    _profile['headline']
  end

  def location
    _profile['locationName']
  end

  def education
    _profile_data.select{ |x| x['$type'] == 'com.linkedin.voyager.identity.profile.Education' }.map do |edu|
      time_period = _profile_data.select{ |x| x['$id'] == edu['timePeriod'] }.first

      {
        school_name: edu['schoolName'],
        major: edu['fieldOfStudy'],
        degree: edu['degreeName'],
        start_date: _start_date(time_period),
        end_date: _end_date(time_period),
      }
    end
  end

  def work_history
    _profile_data.select{ |x| x['$type'] == 'com.linkedin.voyager.identity.profile.Position' }.map do |history|
      time_period = _profile_data.select{ |x| x['$id'] == history['timePeriod'] }.first
      company = _profile_data.select{ |x| x['$id'] == history['company'] }.first
      company_size = _profile_data.select{ |x| x['$id'] == company['employeeCountRange'] }.first

      {
        title: history['title'],
        location: history['locationName'],
        company_name: history['companyName'],
        industry: company['industries'].first,
        description: history['description'],
        start_date: _start_date(time_period),
        end_date: _end_date(time_period),
        company_size: [ company_size['start'], company_size['end'] ].compact.join('-'),
      }
    end
  end

  def profile_image_url
    id = _profile['pictureInfo']
    path = _profile_data.select{ |x| x['$id'] == id }.first['masterImage']
    'https://media.licdn.com/media%s' % path
  rescue
    nil
  end

  def linkedin_url
    path = _profile_data.select{ |x| x['$type'] == 'com.linkedin.voyager.identity.shared.MiniProfile' }.first['publicIdentifier']
    'https://www.linkedin.com/in/%s' % path
  rescue
    nil
  end

  def to_hash
    {
      linkedin_url: linkedin_url,
      profile_image_url: profile_image_url,
      full_name: full_name,
      headline: headline,
      location: location,
      education: education,
      work_history: work_history
    }
  end

  def to_json
    to_hash.to_json
  end

  private

  def _start_date(time_period)
    start_date_info = _profile_data.select{ |x| x['$id'] == time_period['startDate'] }.first
    date_keys = %w(day month year).to_a - start_date_info['$deletedFields']
    start_date = { }
    date_keys.each do |key|
      start_date[key] = start_date_info[key] if start_date_info.key?(key)
    end
    start_date.empty? ? nil : start_date
  end

  def _end_date(time_period)
    end_date_info = _profile_data.select{ |x| x['$id'] == time_period['endDate'] }.first
    date_keys = %w(day month year).to_a - end_date_info['$deletedFields']
    end_date = { }
    date_keys.each do |key|
      end_date[key] = end_date_info[key] if end_date_info.key?(key)
    end
    end_date.empty? ? nil : end_date
  end

  def _profile
    _profile_data.select{ |x| x['$type'] == 'com.linkedin.voyager.identity.profile.Profile' }.first
  end

  def _profile_data
    profile_view['included']
  end
end
