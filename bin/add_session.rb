
# Usage:
#  rails r bin/add_session.rb --email=foo@bar.com --password=xyz123 --user-agent="xxxxxx" --socks-proxy=111.222.33.44:1234

require 'optparse'

info = ARGV.getopts('e:', 'email:', 'p:', 'password:', 'u:', 'user-agent:', 's:', 'socks-proxy:')

redis = Rails.application.redis

TTL = 23 * 60 * 60

session = Extractor::Session.new(
  email: info.fetch('email'),
  password: info.fetch('password'),
  user_agent: info.fetch('user-agent'),
  profile_url_template: ENV.fetch('PROFILE_URL_TEMPLATE'),
  socks_proxy: info.fetch('socks-proxy')
)
begin
  session.sign_in!
  redis.rpush('session-ring', session.email)
  redis.set(('session-hash:%s' % session.email), session.to_json, ex: TTL)
rescue StandardError => e
  abort "ERROR: #{e}"
end

warn 'Finished!'
