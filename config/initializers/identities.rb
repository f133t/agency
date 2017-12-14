
__END__

proxies = File.open('etc/proxies.txt').each_line.map(&:chomp)
logins = File.open('etc/logins.txt').each_line.map(&:chomp)
user_agents = File.open('etc/user_agents.txt').each_line.map(&:chomp)

identities = logins.map do |login|
  user_agent = user_agents.push(user_agents.shift).first
  proxy = proxies.push(proxies.shift).first
  _, _, email, password, _ = login.split(/\:/)
  {
    email: email,
    password: password,
    proxy: proxy,
    user_agent: user_agent
  }
end

pp total: identities.count

identities.each_with_index do |identity, idx|
  session = Extractor::Session.new(
    email: identity[:email],
    password: identity[:password],
    user_agent: identity[:user_agent],
    proxy: identity[:proxy],
    profile_url_template: ENV.fetch('PROFILE_URL_TEMPLATE')
  )
  session.sign_in!
  Rails.application.config.sessions << session

  key = 'identity:%04d' % idx
#  Rails.application.redis.set(key, identity.to_json, exp: )
  pp key => identity.to_json
break
end
