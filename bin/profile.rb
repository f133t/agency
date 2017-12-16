#!/usr/bin/env ruby

profile_urls = ARGV

session = Extractor::Session.new(
  email: ENV.fetch('EMAIL'),
  password: ENV.fetch('PASSWORD'),
  user_agent: ENV.fetch('USER_AGENT'),
  profile_url_template: ENV.fetch('PROFILE_URL_TEMPLATE'),
  socks_proxy: ENV.fetch('SOCKS_PROXY', nil)
)

session.sign_in!

times = [ ]
profiles = profile_urls.map do |profile_url|
  time_start = Time.now.to_f
  profile = session.fetch_profile!(profile_url: profile_url)
  times << Time.now.to_f - time_start
  profile
end

avg_time = times.inject(:+).to_f / times.count.to_f

byebug
puts 'yay'

