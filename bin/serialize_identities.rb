
# Usage:
#  rails r bin/serialize_identities.rb /data/credentials.json > /data/identites.json

credentials_json = ARGV.shift

File.open(credentials_json).each_line do |line|
  info = JSON.parse(line)
  warn '%s...' % info['email']
  session = Extractor::Session.new(
    email: info.fetch('email'),
    password: info.fetch('password'),
    user_agent: info.fetch('user_agent'),
    profile_url_template: ENV.fetch('PROFILE_URL_TEMPLATE'),
    socks_proxy: info.fetch('proxy')
  )
  session.sign_in!
  puts session.to_json
end

warn 'Finished!'
